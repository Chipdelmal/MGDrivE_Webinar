
###############################################################################
# Auxiliary Functions
# -----------------------------------------------------------------------------
#   
###############################################################################

isRstudio = function(){
    rStudio = (Sys.getenv("RSTUDIO") == "1")
    return(rStudio)
}


scriptPath = function(){
    commandArgs(trailingOnly=FALSE)
    return(1)
}

