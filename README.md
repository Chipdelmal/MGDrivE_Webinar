# MGDrivE_Webinar

## Instructions

The contents of this webinar will be accesible in two ways: [github](https://github.com/Chipdelmal/MGDrivE_Webinar) and [docker](https://hub.docker.com/repository/docker/chipdelmal/mgdrive_webinar). Have a look at the following sections for installation in each of these cases!

### GitHub (with local R installation)

Make sure [R](https://www.r-project.org/) and [R-Studio](https://www.rstudio.com/) are installed, then install [MDrivE](https://cran.r-project.org/web/packages/MGDrivE/index.html) and [MGDrivE2](https://cran.r-project.org/web/packages/MGDrivE2/index.html) to your system with the **R** commands:

```R
install.packages('MGDrivE',  dependencies=TRUE, repos='http://cran.rstudio.com/')
install.packages('MGDrivE2', dependencies=TRUE, repos='http://cran.rstudio.com/')
```

Now, download a copy of our [github repository](https://github.com/Chipdelmal/MGDrivE_Webinar). This can be done with either the [Download ZIP](https://github.com/Chipdelmal/MGDrivE_Webinar/archive/refs/heads/main.zip) or the clone alternative:

```bash
git clone git@github.com:Chipdelmal/MGDrivE_Webinar.git
```

You can check if **MGDrivE** was installed correctly by running the [testPkgs](./demos/testPkgs.R) script on the terminal or in **RStudio**:

```bash
Rscript testPkgs.R
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

Try running the [testPkgs](./demos/testPkgs.R) script to make sure **MGDrivE** is running correctly on your session!

Finally, we can always close the **docker** session by hitting `CTRL+C` on the terminal.

**IMPORTANT NOTE:** The changes you make on the files within the Docker container won't be saved across sessions, so make sure to save copies of the files into the `sims_out` folder if you want to make any modifications to the simulation scripts.