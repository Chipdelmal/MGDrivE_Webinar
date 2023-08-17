SHELL=bash

docker_run:
	docker run \
		--rm -p 8787:8787 \
		-e USER="mgdrive" -e PASSWORD="webinar" \
		-v ${PWD}/sims_out:/home/mgdrive/sims_out \
		mgdrive_webinar:dev

docker_build:
	- docker rmi mgdrive_webinar:dev -f
	- docker build -t mgdrive_webinar:dev .

VERSION="1.1.1"
docker_release:
	- docker buildx build . \
		--platform=linux/amd64,linux/arm64,linux/x86_64 \
		-t chipdelmal/mgdrive_webinar:$(VERSION) \
		-t chipdelmal/mgdrive_webinar:latest \
		--push
