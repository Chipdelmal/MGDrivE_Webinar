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
unlink(file.path(PTH_OUT), recursive=TRUE)
dir.create(path=PTH_OUT, recursive=TRUE, showWarnings=FALSE)
###############################################################################
# Sim and Landscape Parameters
###############################################################################
nRep = 20
folderNames = file.path(
  PTH_OUT,
  formatC(x=1:nRep, width=3, format="d", flag="0")
)
simTime = as.integer(365*5)
adultPopEq = 500
movMat = matrix(data=1, nrow=1, ncol=1)
patchPops = rep(adultPopEq, 1)
###############################################################################
# BioParameters
###############################################################################
bioParameters = AE_AEGYPTI
dayOmega = calcOmega(mu=bioParameters$muAd, lifespanReduction=0.80)
omegaNew = c("AA"=dayOmega)
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
    releasesStart=100, releasesNumber=5, releasesInterval=7,
    releaseProportion=100
)
maleReleasesVector = generateReleaseVector(
    driveCube=cube, releasesParameters=releasesParameters
)
releases[[1]]$maleReleases = maleReleasesVector
###############################################################################
# Setup and Run Sim
###############################################################################
setupMGDrivE(stochasticityON=TRUE, verbose=VERBOSE)
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
    directory=folderNames, verbose=VERBOSE
)
MGDrivESim$multRun(verbose=TRUE)
###############################################################################
# Analysis
###############################################################################
for(i in 1:nRep){
  splitOutput(readDir=folderNames[i], remFile=TRUE, verbose=VERBOSE)
  aggregateFemales(
    readDir=folderNames[i], genotypes=cube$genotypesID,
    remFile=TRUE, verbose=FALSE
  )
}
plotMGDrivEMult(readDir=PTH_OUT, lwd=0.25, alpha=0.25)