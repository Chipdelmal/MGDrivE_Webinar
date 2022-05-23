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
dir.create(path = PTH_OUT, recursive = TRUE)
###############################################################################
# Sim Parameters
###############################################################################
simTime = as.integer(365 * 1.75)
repsNumb = 5
folderNames = file.path(
    PTH_OUT,
    formatC(x = 1:repsNumb, width = 3, format = "d", flag = "0")
)
###############################################################################
# Landscape
###############################################################################
adultPopEq = 500
movMat = matrix(data = 1, nrow = 1, ncol = 1)
patchPops = rep(adultPopEq, 1)
###############################################################################
# Entomological Parameters
###############################################################################
bioParameters = list(
    betaK = 20,
    tEgg = 5, tLarva = 6, tPupa = 4,
    popGrowth = 1.175, muAd = 0.09
)
###############################################################################
# Setup Inheritance
###############################################################################
cube = cubeMendelian()
###############################################################################
# Setup Releases
###############################################################################
releases = replicate(
    n = 1,
    expr = {list(maleReleases = NULL, femaleReleases = NULL)}, simplify = FALSE
)
releasesParameters = list(
    releasesStart = 25, releasesNumber = 10, releasesInterval = 7,
    releaseProportion = 100
)
maleReleasesVector = generateReleaseVector(
    driveCube = cube, releasesParameters = releasesParameters
)
femaleReleasesVector = generateReleaseVector(
    driveCube = cube, releasesParameters = releasesParameters
)
releases[[1]]$maleReleases = maleReleasesVector
releases[[1]]$femaleReleases = femaleReleasesVector

