SHELL=bash


dockerBuild:
	- docker rmi mgdrive:dev -f
	- docker build -t mgdrive:dev .