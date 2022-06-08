###############################################################################
# Mendelian Inheritance Demo
#   Source: https://github.com/MarshallLab/MGDrivE/blob/master/Examples/SoftwarePaper/AeAegypti_Software_Replacement.R
#   Original Author: Jared Bennett
###############################################################################
rm(list=ls())
dev.off(dev.list()["RStudioGD"])
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
nRep = 10
folderNames = file.path(
  PTH_OUT,
  formatC(x=1:nRep, width=3, format="d", flag="0")
)
simTime = as.integer(365*10)
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
adultPopEq = 500
popsNum = 4
stayProb = .99975
movMat = Diagonal(n=popsNum, x=stayProb)
for(i in seq(1, 4)){
  movMat[i, i+1] = 1-stayProb
}
movMat[popsNum, 1] = 1-stayProb
movMat = as.matrix(movMat)
patchPops = rep.int(x=adultPopEq, times=popsNum)
###############################################################################
# Releases
###############################################################################
releases = replicate(
  n=popsNum,
  expr={list(maleReleases=NULL, femaleReleases=NULL)}, simplify=FALSE
)
releasesParameters = list(
  releasesStart=25, releasesNumber=3, releasesInterval=7,
  releaseProportion=20
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
    runID=1, simTime=simTime, sampTime=1, nPatch=popsNum,
    beta=bioParameters$betaK, muAd=bioParameters$muAd,
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
MGDrivESim$oneRun(verbose=TRUE)
###############################################################################
# Analysis
###############################################################################
splitOutput(readDir=PTH_OUT, remFile=TRUE, verbose=FALSE)
aggregateFemales(
    readDir=PTH_OUT, genotypes=cube$genotypesID,
    remFile=TRUE, verbose=FALSE
)
tiff(
  file=file.path(PTH_OUT, 'dynamics.tiff'), 
  width=16, height=16, units='cm', compression="lzw", res=175
)
plotMGDrivESingle(readDir=PTH_OUT, totalPop=TRUE, lwd=3.5, alpha=.75)
dev.off()
