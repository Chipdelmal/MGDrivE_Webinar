# MGDrivE_Webinar


This repo contains all the materials and information required for MGDrivE's 2022 webinar to be held on Semptember 8th, 2022 at https://berkeley.zoom.us/j/3458250355.

[![](https://marshalllab.github.io/MGDrivE/images/modelDiagram.png)](https://marshalllab.github.io/MGDrivE/)

<hr>

## Table of Contents

1. [D] [Introduction to MGDrivE](./MD/Intro.md)
2. [D] [Basic Simulations](./MD/Basic.md)
    * [S] [Mendelian with no fitness cost (deterministic)](./demos/MendelianNoCost.R)
    * [S] [Mendelian with fitness cost (deterministic)](./demos/MendelianCost.R)
    * [S] [Mendelian with fitness cost (stochastic)](./demos/MendelianStochastic.R)
    * [S] [Wolbachia (deterministic)](./demos/Wolbachia.R)
    * [S] [Wolbachia (stochastic)](./demos/WolbachiaStochastic.R)
3. [D] [Linked-Drives](./MD/LDR.md)
    * [S] [Linked-Drive Replacement (deterministic in network)](./demos/LDRReplacementDeterministic.R)
    * [S] [Linked-Drive Suppression (deterministic in network)](./demos/LDRSuppressionDeterministic.R)
    * [S] [Linked-Drive Replacement (stochastic in network)](./demos/LDRReplacementStochastic.R)
    * [S] [Linked-Drive Suppression (stochastic in network)](./demos/LDRSuppressionStochastic.R)
4. Environmental Components (MGDrivE2)

**Note:** Items marked with [S] link to **code scripts**, whereas items marked with [D] link to **markdown documents**.

<hr>

## Installation Instructions

The contents of this webinar will be accesible in two ways: [github](https://github.com/Chipdelmal/MGDrivE_Webinar) and [docker](https://hub.docker.com/repository/docker/chipdelmal/mgdrive_webinar). Have a look at the following sections for installation in each of these cases!

### GitHub (with local R installation)

Make sure [R](https://www.r-project.org/) and [R-Studio](https://www.rstudio.com/) are installed, then install [MDrivE](https://cran.r-project.org/web/packages/MGDrivE/index.html) and [MGDrivE2](https://cran.r-project.org/web/packages/MGDrivE2/index.html) to your system with the **R** commands:

```R
install.packages('MGDrivE',  dependencies=TRUE, repos='http://cran.rstudio.com/')
install.packages('MGDrivE2', dependencies=TRUE, repos='http://cran.rstudio.com/')
```

Additionally, we will need the following dependencies for the webinar:

```R
install.packages('rstudioapi')
```


Now, download a copy of our [github repository](https://github.com/Chipdelmal/MGDrivE_Webinar). This can be done with either the [Download ZIP](https://github.com/Chipdelmal/MGDrivE_Webinar/archive/refs/heads/main.zip) or the clone alternative:

```bash
git clone git@github.com:Chipdelmal/MGDrivE_Webinar.git
```

You can check if **MGDrivE** was installed correctly by running the [testPkgs](./demos/testPkgs.R) script on the terminal or in **RStudio**:

```bash
Rscript testPkgs.R
```
**IMPORTANT NOTE:** Do not place any files in the output folders (specially `CSV` ones), as some of the scripts need to clean them up before running the simulations, which could result in loss of information. 

### Docker

Download and install [docker](https://docs.docker.com/get-docker/), then pull our MGDrivE Webinar image from [our dockerhub](https://hub.docker.com/repository/docker/chipdelmal/mgdrive_webinar) with:

```bash
docker pull chipdelmal/mgdrive_webinar:1.0.0
```

To run the image, run the following command in the terminal:

```bash
docker run \
    --rm -p 8787:8787 \
    -e USER="mgdrive" -e PASSWORD="webinar" \
    -v $PWD/sims_out:/home/mgdrive/sims_out \
    chipdelmal/mgdrive_webinar:1.0.0
```  

And now follow the following link on your web-browser (type `mgdrive` as username and `webinar` as password):

```bash
http://localhost:8787
```

Try running the [testPkgs](./demos/testPkgs.R) script to make sure **MGDrivE** is running correctly on your session!

Finally, we can always close the **docker** session by hitting `CTRL+C` on the terminal.

**IMPORTANT NOTE:** The changes you make on the files within the Docker container won't be saved across sessions, so make sure to save copies of the files into the `sims_out` folder if you want to make any modifications to the simulation scripts.

<hr>

## Authors and Funders

* Webinar: [Héctor M. Sánchez C.](https://chipdelmal.github.io/), [Agastya Mondal](https://agastyamondal.com/)
* [MGDrivE](https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/2041-210X.13318): [Héctor M. Sánchez C.](https://chipdelmal.github.io/), [Sean L. Wu](https://slwu89.github.io/), [Jared B. Bennett](https://www.linkedin.com/in/jared-bennett-21a7a9a0?original_referer=https%3A%2F%2Fwww.google.com%2F), [John M. Marshall](https://publichealth.berkeley.edu/people/john-marshall/)
* [MGDrivE2](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1009030): [Sean L. Wu](https://slwu89.github.io/), [Jared B. Bennett](https://www.linkedin.com/in/jared-bennett-21a7a9a0?original_referer=https%3A%2F%2Fwww.google.com%2F), [Héctor M. Sánchez C.](https://chipdelmal.github.io/), [Andrew J. Dolgert](https://www.researchgate.net/profile/Andrew-Dolgert), [Tomás M. León](https://tomasleon.com/), [John M. Marshall](https://publichealth.berkeley.edu/people/john-marshall/)

<img src="https://chipdelmal.github.io/MGSurvE_Presentations/2022_EEID/images/Logos/berkeley.jpg" height="50"> &nbsp; <img src="https://chipdelmal.github.io/MGSurvE_Presentations/2022_EEID/images/Logos/IGI.png" height="50"> &nbsp; <img src="https://chipdelmal.github.io/MGSurvE_Presentations/2022_EEID/images/Logos/gates.jpg" height="50"> 
