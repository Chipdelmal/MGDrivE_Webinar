# MGDrivE_Webinar

## Instructions

Download and install [docker](https://docs.docker.com/get-docker/), then pull our MGDrivE Webinar image from dockerhub with:

```bash
docker pull chipdelmal/mgdrive_webinar
```


To run the image, run the following command in the terminal:

```bash
docker run \
    --rm -p 8787:8787 \
    -e USER="mgdrive" -e PASSWORD="webinar" \
    mgdrive_webinar:dev 
```

    -v "$(pwd)"/MGDrivE_sims:/home/mgdrive/sim_out \

And now follow the following link on your web-browser:

```bash
http://localhost:8787
```