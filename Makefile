SHELL=bash

dockerBuild:
	- docker rmi mgdrive_webinar:dev -f
	- docker build -t mgdrive_webinar:dev .


VERSION="0.1.1"
dockerRelease:
	- docker rmi chipdelmal/mgdrive_webinar:$(VERSION) -f
	- docker build -t chipdelmal/mgdrive_webinar:$(VERSION) .
	- docker push chipdelmal/mgdrive_webinar:$(VERSION)