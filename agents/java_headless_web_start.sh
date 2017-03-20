
#!/bin/bash

# gets the jenkins cli jar file to perform the other steps
curl -O http://dockerserver:8090/jnlpJars/jenkins-cli.jar

# creates the node to be in foreground so browsers can open.  ONLY needed for GUI UI testing stuff
# but could be used for other normal back ground build stuff
java -jar jenkins-cli.jar -s http://dockerserver:8090/ create-node Headless_UI < corndog.xml

# launches the agent for use
java -jar slave.jar -jnlpUrl http://dockerserver:8090/computer/Headless_UI/slave-agent.jnlp 2>&1>/dev/null &
