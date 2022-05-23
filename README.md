# MGDrivE_Webinar

## Instructions

### GitHub (with local R installation)

Make sure [R](https://www.r-project.org/) and [R-Studio](https://www.rstudio.com/) are installed, then install [MDrivE](https://cran.r-project.org/web/packages/MGDrivE/index.html) and [MGDrivE2](https://cran.r-project.org/web/packages/MGDrivE2/index.html) to your system with the **R** commands:

```R
install.packages('MGDrivE',  dependencies=TRUE, repos='http://cran.rstudio.com/')
install.packages('MGDrivE2', dependencies=TRUE, repos='http://cran.rstudio.com/')
```

### Docker

Download and install [docker](https://docs.docker.com/get-docker/), then pull our MGDrivE Webinar image from dockerhub with:

```bash
docker pull chipdelmal/mgdrive_webinar
```


To run the image, run the following command in the terminal:

```bash
docker run \
    --rm -p 8787:8787 \
    -e USER="mgdrive" -e PASSWORD="webinar" \
    -v "$(pwd)"/MGDrivE_sims:/home/mgdrive/sims_out \
    mgdrive_webinar:dev 
```  

And now follow the following link on your web-browser:

```bash
http://localhost:8787
```