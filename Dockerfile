FROM rocker/rstudio
LABEL maintainer="Hector M. Sanchez C. <sanchez.hmsc@berkeley.edu>"
###############################################################################
# Setup Structure
###############################################################################
RUN mkdir /home/mgdrive \
    && mkdir /home/mgdrive/demos \
    && mkdir /home/mgdrive/sims_out
COPY README.md /home/mgdrive
COPY ./demos/ /home/mgdrive/demos
###############################################################################
# Install R Packages
###############################################################################
RUN R -e "install.packages('MGDrivE', dependencies=TRUE, repos='http://cran.rstudio.com/')" \
    && R -e "install.packages('MGDrivE2', dependencies=TRUE, repos='http://cran.rstudio.com/')" \
    && R -e "install.packages('rstudioapi', dependencies=TRUE, repos='http://cran.rstudio.com/')" 
###############################################################################
# Install Linux Packages
###############################################################################
RUN apt-get update \
    && apt-get install nano \
    && apt-get install -y --no-install-recommends libxt6 \
    && apt-get install htop