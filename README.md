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
    -v "$(pwd)"/MGDrivE_sims:/home/mgdrive/sims_out \
    mgdrive_webinar:dev 
```

    

And now follow the following link on your web-browser:

```bash
http://localhost:8787
```