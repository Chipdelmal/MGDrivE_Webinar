###############################################################################
# Linked Drive Replacement Demo
#   Source: https://github.com/MarshallLab/MGDrivE/blob/master/Examples/SoftwarePaper/AeAegypti_Software_Replacement.R
#   Original Authors: Héctor M. Sánchez C. & Jared Bennett & Sean L. Wu
#   Modified by: Héctor M. Sánchez C.
###############################################################################
rm(list=ls())
if(!is.na(dev.list()["RStudioGD"][[1]])){dev.off(dev.list()["RStudioGD"])}
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
# BioParameters
###############################################################################
bioParameters = AE_AEGYPTI
sH = .25
sR = .25
sB = .50
eM = 0.9
eF = 0.5
cube=cubeHomingDrive(
  cM=1, cF=1, chM=eM, crM=1/3, chF=eF, crF=1/3,
  s=c(
    "WW"=1,       "WH"=1-sH, 
    "WR"=1-sR,    "WB"=1-sB,
    "HH"=1-2*sH,  "HR"=1-sH-sR, 
    "HB"=1-sH-sB, "RR"=1-2*sR, 
    "RB"=1-sR-sB, "BB"=1-2*sB
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
setupMGDrivE(stochasticityON=FALSE, verbose=VERBOSE)
netPar = parameterizeMGDrivE(
    runID=1, simTime=as.integer(SIM_TIME), sampTime=SAMPLE_TIME, 
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
    directory=PTH_OUT, verbose=VERBOSE
)
MGDrivESim$oneRun(verbose=TRUE)
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