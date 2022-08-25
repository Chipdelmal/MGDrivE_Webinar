# Check if MGDrivE is installed correctly
pkgInstalled = c(
    require(MGDrivE), require(MGDrivE2), 
    require(Matrix), require(ggplot2)
)
pkgFlags = all(pkgInstalled)
# Print message with result
if(pkgFlags){
    print("MGDrivE is installed correctly in the system!")
}else{
    print("There are errors with your MGDrivE installation!")
}
