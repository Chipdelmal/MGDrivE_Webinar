SHELL=bash


dockerRun:
	docker run \
		--rm -p 8787:8787 \
		-e USER="mgdrive" -e PASSWORD="webinar" \
		-v "$(pwd)"/MGDrivE_sims:/home/mgdrive/sims_out \
		mgdrive_webinar:dev


dockerBuild:
	- docker rmi mgdrive_webinar:dev -f
	- docker build -t mgdrive_webinar:dev .


VERSION="0.1.1"
dockerRelease:
	- docker rmi chipdelmal/mgdrive_webinar:$(VERSION) -f
	- docker build -t chipdelmal/mgdrive_webinar:$(VERSION) .
	- docker push chipdelmal/mgdrive_webinar:$(VERSION)
