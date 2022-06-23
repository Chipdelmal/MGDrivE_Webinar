SHELL=bash


dockerRun:
	docker run \
		--rm -p 8787:8787 \
		-e USER="mgdrive" -e PASSWORD="webinar" \
		-v $PWD/sims_out:/home/mgdrive/sims_out \
		mgdrive_webinar:dev


dockerBuild:
	- docker rmi mgdrive_webinar:dev -f
	- docker build -t mgdrive_webinar:dev .


VERSION="0.1.2"
dockerRelease:
	- docker rmi chipdelmal/mgdrive_webinar:$(VERSION) -f
	- docker build -t chipdelmal/mgdrive_webinar:$(VERSION) .
	- docker push chipdelmal/mgdrive_webinar:$(VERSION)
