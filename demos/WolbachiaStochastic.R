###############################################################################
# Wolbachia IIT Demo
# -----------------------------------------------------------------------------
#   Original Authors: Héctor M. Sánchez C. & Jared Bennett
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
unlink(file.path(PTH_OUT), recursive=TRUE)
dir.create(path=PTH_OUT, recursive=TRUE, showWarnings=FALSE)
###############################################################################
# Sim and Landscape Parameters
###############################################################################
folderNames = file.path(
  PTH_OUT, formatC(x=1:(2*REPS), width=3, format="d", flag="0")
)
movMat = matrix(data=1, nrow=1, ncol=1)
patchPops = rep(ADULT_EQ, 1)
###############################################################################
# BioParameters
###############################################################################
bioParameters = AE_AEGYPTI
dayOmega = calcOmega(mu=bioParameters$muAd, lifespanReduction=0.9)
omegaNew = c("W"=dayOmega)
cube = cubeWolbachia(omega=omegaNew)
###############################################################################
# Releases
###############################################################################
popsNum = 1
releases = replicate(
  n=popsNum, simplify=FALSE,
  expr={list(maleReleases=NULL, femaleReleases=NULL)}
)
# Male -----------------------------------------------------------------------
releasesParametersMale = list(
  releasesStart=REL_START, releasesInterval=REL_INTERVAL,
  releasesNumber=REL_NUM, releaseProportion=as.integer(ADULT_EQ*10)
)
maleReleasesVector = generateReleaseVector(
  driveCube=cube, releasesParameters=releasesParametersMale
)
releases[[1]]$maleReleases = maleReleasesVector
# Female ---------------------------------------------------------------------
releasesParametersFemale = list(
  releasesStart=REL_START, releasesInterval=REL_INTERVAL,
  releasesNumber=1, releaseProportion=1
)
femaleReleasesVector = generateReleaseVector(
  driveCube=cube, releasesParameters=releasesParametersFemale
)
releases[[1]]$femaleReleases = femaleReleasesVector
###############################################################################
# Setup and Run Sim
###############################################################################
setupMGDrivE(stochasticityON=TRUE, verbose=VERBOSE)
netPar = parameterizeMGDrivE(
  runID=1, simTime=as.integer(SIM_TIME/3), sampTime=SAMPLE_TIME, 
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
  directory=folderNames, verbose=VERBOSE
)
MGDrivESim$multRun(verbose=TRUE)
###############################################################################
# Analysis
###############################################################################
for(i in 1:(2*REPS)){
  splitOutput(readDir=folderNames[i], remFile=TRUE, verbose=VERBOSE)
  aggregateFemales(
    readDir=folderNames[i], genotypes=cube$genotypesID,
    remFile=TRUE, verbose=FALSE
  )
}
if(PLOT_TO_FILE){
  tiff(
    file=file.path(PTH_OUT, 'dynamics.tiff'), 
    width=36, height=16, units='cm', compression="lzw", res=175
  )
  plotMGDrivEMult(readDir=PTH_OUT, lwd=0.25, alpha=0.5, totalPop=TRUE)
  dev.off()
}else{
  plotMGDrivEMult(readDir=PTH_OUT, lwd=0.25, alpha=0.5, totalPop=TRUE)
}
