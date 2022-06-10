###############################################################################
# Run All Experiments
# -----------------------------------------------------------------------------
#   Author: Héctor M. Sánchez C.
###############################################################################
rm(list=ls())
if(any(!is.na(dev.list()["RStudioGD"]))){dev.off(dev.list()["RStudioGD"])}
###############################################################################
# Loading Libraries and Setting Paths Up
###############################################################################
# Get script path and directory -----------------------------------------------
fPath = rstudioapi::getSourceEditorContext()$path
dirname = dirname(fPath); basename = basename(fPath)
# Set working directory to one above script's location ------------------------
setwd(dirname); setwd('..')
###############################################################################
# Run all the examples
###############################################################################
fNames = list(
    'MendelianNoCost', 'MendelianCost', 'MendelianStochastic', 
    'Wolbachia', 'WolbachiaStochastic',
    'LDRReplacementDeterministic', 'LDRReplacementStochastic',
    'LDRSuppressionDeterministic', 'LDRSuppressionStochastic'
)
for(file in fNames){
    source(paste0('./demos/', file, '.R'))
}
