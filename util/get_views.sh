#!/bin/bash

# #####################
# Pre-requisits
# #####################
#    jq - json query utility to parse Json.  Installation can be found on
#         stedolan.github.io/jq/download
#    On RedHat/CentOS use the following commands
#      yum install epel-release -y
#      yum install jq -y
#      jq --version
# #####################
# Resource references
# #####################
# command string parsing (ex: ${str// *} or ${str#\"} or ${str//\"}
#    - www.thegeekstuff.com/2010/07/bash-string-manipulation
#    - www.thegeekstuff.com/2010/06/bash-array-tutorial
#

#check if the jq is installed
res="$(jq --version)"
if [ -z "$res" ]
then
   echo "The program 'jq' is currently not installed. "
   echo "You can install it by typing:"
   echo "   sudo apt install jq"
   echo "or on centos"
   echo "   yum install epel-release -y"
   echo "   yum install jq -y"
   exit -1
else
   echo "Using jq version: $res"
fi

echo "###"
echo "### Getting Jenkins Views"
echo "###"

for viewName in `curl -s http://dockerserver:8090/api/json?pretty=true|jq ".views[].name"`
do
   viewName="${viewName//\"}"
   if [ "$viewName" != "all" ]
   then
      echo "   $viewName"
      curl -s http://dockerserver:8090/view/$viewName/config.xml -o ../views/$viewName.xml
   fi
done
