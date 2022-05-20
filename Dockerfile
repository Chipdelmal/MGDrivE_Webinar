FROM r-base

RUN R -e "install.packages('MGDrivE', dependencies=TRUE, repos='http://cran.rstudio.com/')" \
    && R -e "install.packages('MGDrivE2', dependencies=TRUE, repos='http://cran.rstudio.com/')"