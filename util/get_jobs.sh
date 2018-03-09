#!/bin/bash

# #####################
# Pre-requisits
# #####################
#    jq - json query utility to parse Json.  Installation can be found on
#         stedolan.github.io/jq/download
#
#    inspiration for using this came from http://stackoverflow.com/questions/14843874/from-jenkins-how-do-i-get-a-list-of-the-currently-running-jobs-in-json
#    https://stedolan.github.io/jq/
#    jq can be installed in centos/redhat using (https://stackoverflow.com/questions/44044449/facing-issue-while-installing-jq-in-centos)
#    yum install epel-release -y
#    yum install jq -y
#    jq --version

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

# use the following for easier viewing
# curl http://dockerserver:8090/api/json?pretty=true
jobs=`curl -s http://dockerserver:8090/api/json|jq ".jobs"`

jobCnt=`echo $jobs|jq ".|length"`

echo "###"
echo "### Getting Jenkins Jobs"
echo "###"
for ((i=0; i<$jobCnt; i++))
do

   jobName=`echo $jobs|jq ".[$i].name"`
   jobName="${jobName//\"}"
   jobUrl=`echo $jobs|jq ".[$i].url"`
   jobUrl="${jobUrl//\"}"
   echo "   $jobName"
   curl -s "$jobUrl/config.xml" -o ../jobs/$jobName.xml
done
