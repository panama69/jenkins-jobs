#!/bin/bash
# #####################
# Pre-requisits
# #####################
#    jq - json query utility to parse Json.  Installation can be found on
#         stedolan.github.io/jq/download
#
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
   exit -1
else
   echo "Using jq version: $res"
fi

jenkinsServer="dockerserver:8090"

useCrumbs=`curl -s http://$jenkinsServer/api/json|jq ".useCrumbs"`

if [ "$useCrumbs" = "true" ]
then
   echo "Using Crumbs since Jenkins->Manage Jenkins->Configure Global Security->Prevent Cross Site Request Forgery exploits is turned on"
   #CSRF solution found at
   #http://stackoverflow.com/questions/28577551/how-to-disable-a-jenkins-job-via-curl
   #http://stackoverflow.com/questions/8424228/export-import-jobs-in-jenkins
   #https://benkiew.wordpress.com/2012/01/12/automating-hudsonjenkins-via-rest-and-curl-a-very-small-cookbook/

   #CRUMB=$(curl -s 'http://USER:TOKEN@localhost:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)')
   CRUMB=$(curl -s 'http://dockerServer:8090/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)')
   #echo " The crumb is: $CRUMB"
fi

echo "###"
echo "### Process Views"
echo "###"
for fileName in ../views/*.xml
do
   viewName=${fileName%\.xml}
   viewName=${viewName#\../views/}
   url="http://$jenkinsServer/createView?name=$viewName"

   echo "      $viewName"
   if [ "$useCrumbs" = "true" ]
   then
      curl -X POST -H $CRUMB -H "Content-Type: application/xml" $url -d @$fileName
   else
      curl -X POST -H "Content-Type: application/xml" $url -d @$fileName
   fi
done

echo "###"
echo "### Process Jobs"
echo "###"
for fileName in ../jobs/*.xml
do
   jobName=${fileName%\.xml}
   jobName=${jobName#\../jobs/}
   url="http://$jenkinsServer/createItem?name=$jobName"

   echo "      $jobName"
   if [ "$useCrumbs" = "true" ]
   then
      curl -X POST -H $CRUMB -H "Content-Type: application/xml" $url -d @$fileName
   else
      curl -X POST -H "Content-Type: application/xml" $url -d @$fileName
   fi
done

##
## To dynamically disable a job
## 
#curl -X POST -H "$CRUMB" http://USER:TOKEN@localhost:8080/<jobname>/disable
#curl -X POST -H "$CRUMB" http://server:port/<jobname>/disable


###
### "Triggered a build"
###
#https://support.cloudbees.com/hc/en-us/articles/218889337-How-to-build-a-job-using-the-REST-API-and-cURL
#curl -X POST http://developer:developer@localhost:8080/job/test/build
#curl -X POST -H $CRUMB http://$jenkinsServer/job/LFT_Octane_Gherkin/build
