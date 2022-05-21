SHELL=bash


dockerBuild:
	- docker rmi mgdrive_webinar:dev -f
	- docker build -t mgdrive_webinar:dev .