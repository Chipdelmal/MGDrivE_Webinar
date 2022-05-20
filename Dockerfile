FROM rocker/r-ver
###############################################################################
# Setup Structure
###############################################################################
RUN apt-get update \
    && apt-get install nano \
    && rm -rf /var/lib/apt/lists/*
###############################################################################
# Install MGDrivE
###############################################################################
RUN R -e "install.packages('MGDrivE', dependencies=TRUE, repos='http://cran.rstudio.com/')" \
    && R -e "install.packages('MGDrivE2', dependencies=TRUE, repos='http://cran.rstudio.com/')"