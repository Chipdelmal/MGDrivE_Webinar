###############################################################################
# Linked Drive Suppression Demo
#   Source: https://github.com/MarshallLab/MGDrivE/blob/master/Examples/SoftwarePaper/AeAegypti_Software_Suppression.R
#   Original Authors: Héctor M. Sánchez C. & Jared Bennett & Sean L. Wu
#   Modified by: Héctor M. Sánchez C.
###############################################################################
rm(list=ls())
if(any(!is.na(dev.list()["RStudioGD"]))){dev.off(dev.list()["RStudioGD"])}
###############################################################################
# Loading Libraries and Setting Paths Up
###############################################################################
library(MGDrivE); library(Matrix)
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
# Sim Parameters
###############################################################################
folderNames = file.path(
  PTH_OUT, formatC(x=1:(REPS), width=3, format="d", flag="0")
)
movMat = matrix(data=1, nrow=1, ncol=1)
patchPops = rep(ADULT_EQ, 1)
###############################################################################
# BioParameters
###############################################################################
bioParameters = AE_AEGYPTI
sHet=.9
eM=0.999
eF=0.999
cube=cubeHomingDrive(
  cM=.9999, cF=.9999, chM=eM, crM=1/30, chF=eF, crF=1/30,
  s=c(
    "WW"=1, "WH"=1-sHet, "WR"=1, "WB"=1-sHet,
    "HH"=0, "HR"=1-sHet, "HB"=0,
    "RR"=1, "RB"=1-sHet,
    "BB"=0
  )
)
###############################################################################
# Landscape Parameters
###############################################################################
movMat = Diagonal(n=POPS_NET_NUM, x=P_STAY)
for(i in seq(1, POPS_NET_NUM-1)){
  movMat[i, i+1] = 1-P_STAY
}
movMat[POPS_NET_NUM, 1] = 1-P_STAY
movMat = as.matrix(movMat)
patchPops = rep.int(x=ADULT_EQ, times=POPS_NET_NUM)
###############################################################################
# Releases
###############################################################################
releases = replicate(
  n=POPS_NET_NUM, simplify=FALSE,
  expr={list(maleReleases=NULL, femaleReleases=NULL)}
)
releasesParameters = list(
    releasesStart=REL_START, releasesInterval=REL_INTERVAL,
    releasesNumber=REL_NUM, releaseProportion=as.integer(ADULT_EQ/10)
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
  runID=1, simTime=as.integer(SIM_TIME/3), sampTime=SAMPLE_TIME, 
  nPatch=POPS_NET_NUM, beta=bioParameters$betaK, muAd=bioParameters$muAd,
  popGrowth=bioParameters$popGrowth, tEgg=bioParameters$tEgg,
  tLarva=bioParameters$tLarva, tPupa=bioParameters$tPupa,
  AdPopEQ=patchPops, inheritanceCube=cube
)
batchMig = basicBatchMigration(
  batchProbs=0, sexProbs=c(.5, .5), numPatches=POPS_NET_NUM
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
    width=16, height=16, units='cm', compression="lzw", res=175
  )
  plotMGDrivEMult(readDir=PTH_OUT, lwd=0.25, alpha=0.5, totalPop=TRUE)
  dev.off()
}else{
  plotMGDrivEMult(readDir=PTH_OUT, lwd=0.25, alpha=0.5, totalPop=TRUE)
}

