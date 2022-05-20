FROM rocker/rstudio
###############################################################################
# Setup Structure
###############################################################################
COPY README.md /home/mgdrive/
###############################################################################
# Install MGDrivE
###############################################################################
RUN R -e "install.packages('MGDrivE', dependencies=TRUE, repos='http://cran.rstudio.com/')" \
    && R -e "install.packages('MGDrivE2', dependencies=TRUE, repos='http://cran.rstudio.com/')"
