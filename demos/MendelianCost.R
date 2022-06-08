###############################################################################
# Mendelian Inheritance Demo
#   Source: https://marshalllab.github.io/MGDrivE/docs_v1/articles/mgdrive_examples.html
#   Original Author: Jared Bennett
###############################################################################
rm(list=ls())
dev.off(dev.list()["RStudioGD"])
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
dir.create(path=PTH_OUT, recursive=TRUE, showWarnings=FALSE)
unlink(file.path(PTH_OUT, "*.csv"))
###############################################################################
# Sim and Landscape Parameters
###############################################################################
simTime = as.integer(365*1.75)
adultPopEq = 500
movMat = matrix(data=1, nrow=1, ncol=1)
patchPops = rep(adultPopEq, 1)
###############################################################################
# BioParameters
###############################################################################
bioParameters = AE_AEGYPTI
dayOmega = calcOmega(mu=bioParameters$muAd, lifespanReduction=0.60)
omegaNew = c("aa"=dayOmega)
cube = cubeMendelian(omega=omegaNew)
###############################################################################
# Releases
###############################################################################
sitesNumber = 1
releases = replicate(
    n=sitesNumber,
    expr={list(maleReleases=NULL, femaleReleases=NULL)}, simplify=FALSE
)
releasesParameters = list(
    releasesStart=25, releasesNumber=10, releasesInterval=7,
    releaseProportion=100
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
    runID=1, simTime=simTime, sampTime=1, nPatch=sitesNumber,
    beta=bioParameters$betaK, muAd=bioParameters$muAd,
    popGrowth=bioParameters$popGrowth, tEgg=bioParameters$tEgg,
    tLarva=bioParameters$tLarva, tPupa=bioParameters$tPupa,
    AdPopEQ=patchPops, inheritanceCube=cube
)
batchMig = basicBatchMigration(
    batchProbs=0, sexProbs=c(.5, .5), numPatches=sitesNumber
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
# tiff(
#   file=file.path(PTH_OUT, 'dynamics.tiff'), 
#   width=36, height=16, units='cm', compression="lzw", res=175
# )
plotMGDrivESingle(readDir=PTH_OUT, totalPop=TRUE, lwd=3.5, alpha=.75)
# dev.off()