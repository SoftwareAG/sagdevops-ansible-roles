#!/bin/bash
#Software AG Installer API Gateway Image script created on @ Wed Feb 17 04:52:22 UTC 2021 

replacePathsInFiles() {
    for file in `find ${SAG_HOME} -type f -exec grep -il "${SAG_HOME_ORIG}" {} \; | grep -vE "\.log|\.jar"`
    do
       echo "apigw_updatePath.sh: update the path in $file"
       sed -i "s!${SAG_HOME_ORIG}/!${SAG_HOME}/!g" $file
    done
}

if [ "$SAG_HOME" != "/opt/softwareag" ]
then
    SAG_HOME_ORIG=/opt/softwareag
    replacePathsInFiles
fi