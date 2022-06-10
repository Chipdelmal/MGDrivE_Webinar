###############################################################################
# Mendelian Inheritance Demo
# -----------------------------------------------------------------------------
#   Source: https://marshalllab.github.io/MGDrivE/docs_v1/articles/mgdrive_examples.html
#   Original Author: Jared Bennett
#   Modified by: Héctor M. Sánchez C.
###############################################################################
rm(list=ls())
if(any(!is.na(dev.list()["RStudioGD"]))){dev.off(dev.list()["RStudioGD"])}
###############################################################################
# Loading Libraries and Setting Paths Up
###############################################################################
library(MGDrivE)
# Get script path and directory -----------------------------------------------
fPath = rstudioapi::getSourceEditorContext()$path
dirname = dirname(fPath); basename = basename(fPath)
# Set working directory to one above script's location ------------------------
setwd(dirname); setwd('..')
FLD_OUT = tools::file_path_sans_ext(basename)
# Load constants shared across the session ------------------------------------
source("./demos/constants.R")
# Setup output folder and delete CSV files in it ------------------------------
PTH_OUT = file.path(GLB_PTH_OUT, FLD_OUT)
unlink(file.path(PTH_OUT, "*.csv"))
dir.create(path=PTH_OUT, recursive=TRUE, showWarnings=FALSE)
###############################################################################
# Landscape Parameters
###############################################################################
movMat = matrix(data=1, nrow=1, ncol=1)
patchPops = rep(ADULT_EQ, 1)
###############################################################################
# BioParameters
###############################################################################
bioParameters = AE_AEGYPTI
cube = cubeMendelian()
###############################################################################
# Releases
###############################################################################
popsNum = 1
releases = replicate(
    n=popsNum, simplify=FALSE,
    expr={list(maleReleases=NULL, femaleReleases=NULL)}
)
releasesParameters = list(
    releasesStart=REL_START, releasesInterval=REL_INTERVAL,
    releasesNumber=REL_NUM, releaseProportion=as.integer(ADULT_EQ*.1)
)
maleReleasesVector = generateReleaseVector(
    driveCube=cube, releasesParameters=releasesParameters
)
releases[[1]]$maleReleases = maleReleasesVector
###############################################################################
# Setup and Run Sim
###############################################################################
setupMGDrivE(stochasticityON=FALSE, verbose=VERBOSE)
netPar = parameterizeMGDrivE(
    runID=1, simTime=as.integer(SIM_TIME/5), sampTime=SAMPLE_TIME, 
    nPatch=popsNum, beta=bioParameters$betaK, muAd=bioParameters$muAd,
    popGrowth=bioParameters$popGrowth, tEgg=bioParameters$tEgg,
    tLarva=bioParameters$tLarva, tPupa=bioParameters$tPupa,
    AdPopEQ=patchPops, inheritanceCube=cube
)
batchMig = basicBatchMigration(
    batchProbs=0, sexProbs=c(.5, .5), numPatches=popsNum
)
MGDrivESim = Network$new(
    params=netPar, driveCube=cube, patchReleases=releases,
    migrationMale=movMat, migrationFemale=movMat, migrationBatch=batchMig,
    directory=PTH_OUT, verbose=VERBOSE
)
MGDrivESim$oneRun(verbose=VERBOSE)
###############################################################################
# Analysis
###############################################################################
splitOutput(readDir=PTH_OUT, remFile=TRUE, verbose=FALSE)
aggregateFemales(
    readDir=PTH_OUT, genotypes=cube$genotypesID,
    remFile=TRUE, verbose=FALSE
)
if(PLOT_TO_FILE){
    tiff(
        file=file.path(PTH_OUT, 'dynamics.tiff'), 
        width=36, height=16, units='cm', compression="lzw", res=175
    )
    plotMGDrivESingle(readDir=PTH_OUT, totalPop=TRUE, lwd=3.5, alpha=.75)
    dev.off()
}else{
    plotMGDrivESingle(readDir=PTH_OUT, totalPop=TRUE, lwd=3.5, alpha=.75)
}
