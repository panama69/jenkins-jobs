#Agents
This folder contains:
* DockerServer.xml - defines the Jenkins slave agent run on DockerServer_v5 and was created based on the devops:V10 image
* DockerClient.xml - defines the Jenkins slave agent run on DockerClient_v4 and was created based on the devops:V10 image
* corndog.xml - defines a Jenkins slave agent which stars using javaws (webstart) so GUI (browser tests) can be run on Ubuntu

java_web_start_install.sh - is a script which automates the deployment/creation of the corndog agent and uses the Jenkins CLI API's to perform the task.  The script also installs javaws (webstart) since it wasn't part of the DockerServer_v5 release.
