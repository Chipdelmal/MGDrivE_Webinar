
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
    args = commandArgs(trailingOnly=FALSE)
    return(args)
}

