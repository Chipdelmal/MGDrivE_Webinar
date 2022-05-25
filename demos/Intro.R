###############################################################################
# Mendelian Inheritance Demo
#   Source: https://marshalllab.github.io/MGDrivE/docs_v1/articles/mgdrive_examples.html
#   Original Author: Jared Bennett
###############################################################################

###############################################################################
# Loading Libraries
###############################################################################
library(MGDrivE); # library(MGDrivE2);
source("./demos/constants.R")
###############################################################################
# Setting Paths Up
###############################################################################
FLD_OUT = "Intro"
PTH_OUT = file.path(GLB_PTH_OUT, FLD_OUT)
dir.create(path=PTH_OUT, recursive=TRUE)
###############################################################################
# Sim Parameters
###############################################################################
simTime = as.integer(365*1.75)
# repsNumb = 5
# folderNames = file.path(
#     PTH_OUT,
#     formatC(x = 1:repsNumb, width=3, format="d", flag="0")
# )
###############################################################################
# Landscape
###############################################################################
adultPopEq = 500
movMat = matrix(data=1, nrow=1, ncol=1)
patchPops = rep(adultPopEq, 1)
###############################################################################
# Entomological Parameters
###############################################################################
bioParameters = list(
    tEgg=5, tLarva=6, tPupa=4,
    betaK=20, popGrowth=1.175, muAd=0.09
)
###############################################################################
# Setup Inheritance
###############################################################################
cube = cubeMendelian()
###############################################################################
# Setup Releases
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
femaleReleasesVector = generateReleaseVector(
    driveCube=cube, releasesParameters=releasesParameters
)
releases[[1]]$maleReleases = maleReleasesVector
releases[[1]]$femaleReleases = femaleReleasesVector
###############################################################################
# Setup and Run Sim
###############################################################################
setupMGDrivE(stochasticityON = FALSE, verbose = FALSE)
netPar = parameterizeMGDrivE(
    runID=1, simTime=simTime, sampTime=1, nPatch=sitesNumber,
    beta=bioParameters$betaK, muAd=bioParameters$muAd,
    popGrowth=bioParameters$popGrowth, tEgg=bioParameters$tEgg,
    tLarva=bioParameters$tLarva, tPupa=bioParameters$tPupa,
    AdPopEQ=adultPopEq, inheritanceCube=cube
)
batchMig = basicBatchMigration(
    batchProbs=0, sexProbs=c(.5,.5), numPatches=sitesNumber
)
MGDrivESim = Network$new(
    params=netPar, driveCube=cube, patchReleases=releases,
    migrationMale=movMat, migrationFemale=movMat, migrationBatch=batchMig,
    directory=PTH_OUT, verbose=FALSE
)
MGDrivESim$oneRun(verbose=FALSE)
###############################################################################
# Analysis
###############################################################################
splitOutput(readDir=PTH_OUT, remFile=TRUE, verbose=FALSE)
aggregateFemales(
    readDir=PTH_OUT, genotypes=cube$genotypesID,
    remFile=TRUE, verbose=FALSE
)
plotMGDrivESingle(readDir=PTH_OUT, totalPop=TRUE, lwd=3.5, alpha=1)
