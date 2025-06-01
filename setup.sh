#!/bin/bash
############Documentation of this Shellscript##########
#This Script will setup this Project
#run ./setup.sh to tun this project
###########Define Functions##################################
function installpackage(){
    local packageName=${1}
    
    if ! apt-get install -y ${packageName}
then
    echo "not able to install ${packageName}"
exit 1
fi
}
function mavenTarget(){
    local mavencmd=${1}
    
if ! mvn ${mavencmd}
then
   echo "Test fail"
   exit 1
fi
}
# - check is user a root user.
if [[ $UID != 0 ]]
then
    echo "user is not a root user"
    exit 1
fi
##############################Define Variables#################################
read -p "please enter accesss path "  APP_CONTEXT
APP_CONTEXT=${APP_CONTEXT:-app}
# - apt-get update

if ! apt-get update
then
   echo "not able to update the repository"
   exit 1
fi 
#Function installpackage call
installpackage maven
installpackage tomcat9
# - mvn test
mavenTarget test
# - mvn package
mavenTarget package
if cp -rvf target/hello-world-0.0.1-SNAPSHOT.war /var/lib/tomcat9/webapps/${APP_CONTEXT}.war
then
echo "Application Deployed Successfully.You can access it on http//:"{IP ADDRESS/${APP_CONTEXT}}
else
echo "do not able to deploy the application"
fi
exit 0

