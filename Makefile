SHELL=bash


dockerBuild:
	- docker rmi mgdrive:dev
	- docker build -t mgdrive:dev .