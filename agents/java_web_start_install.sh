#!/bin/bash

# Installs java web start (javaws)
sudo apt-get install icedtea-netx

# gets the jenkins cli jar file to perform the other steps
curl -O http://dockerserver:8090/jnlpJars/jenkins-cli.jar

# creates the node to be in foreground so browsers can open.  ONLY needed for GUI UI testing stuff
# but could be used for other normal back ground build stuff
java -jar jenkins-cli.jar -s http://dockerserver:8090/ create-node corndog < corndog.xml

# launches the agent for use
javaws http://dockerserver:8090/computer/corndog/slave-agent.jnlp 2>&1>/dev/null &

