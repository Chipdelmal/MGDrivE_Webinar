FROM rocker/rstudio
###############################################################################
# Setup Structure
###############################################################################
COPY README.md /home/mgdrive/
###############################################################################
# Install
###############################################################################
# RUN R -e "install.packages('MGDrivE', dependencies=TRUE, repos='http://cran.rstudio.com/')" \
#     && R -e "install.packages('MGDrivE2', dependencies=TRUE, repos='http://cran.rstudio.com/')"
###############################################################################
# Testing
###############################################################################

# docker run --rm -p 8787:8787 -e USER="mgdrive" -e PASSWORD="webinar" mgdrive:dev
# localhost:8787