FROM rocker/rstudio
MAINTAINER HectorMSanchezC <sanchez.hmsc@berkeley.edu>
###############################################################################
# Setup Structure
###############################################################################
RUN mkdir /home/mgdrive
# WORKDIR /home/mgdrive
COPY README.md /home/mgdrive
COPY ./Demos /home/mgdrive
###############################################################################
# Install MGDrivE
###############################################################################
# RUN R -e "install.packages('MGDrivE', dependencies=TRUE, repos='http://cran.rstudio.com/')" \
#     && R -e "install.packages('MGDrivE2', dependencies=TRUE, repos='http://cran.rstudio.com/')"
