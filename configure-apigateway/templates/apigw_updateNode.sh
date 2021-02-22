#!/bin/bash

NODENAME=`cat /etc/hostname`
export SAG_HOME=/opt/softwareag
export JAVA_HOME=${SAG_HOME}/jvm/jvm
STATFILE=/tmp/init_container
LOGFILE=${SAG_HOME}/IntegrationServer/instances/default/logs/updateNode.log

if [ ! -d "${SAG_HOME}/IntegrationServer/instances/default/logs" ]
then
    mkdir "${SAG_HOME}/IntegrationServer/instances/default/logs"
fi

touch $LOGFILE

if [ -f $STATFILE ]
then
   :
else
   ${JAVA_HOME}/bin/java -cp ${SAG_HOME}/IntegrationServer/instances/default/packages/WmAPIGateway/bin/lib/apigateway-tools.jar com.softwareag.apigateway.tools.docker.ModifyExternalProperties default | tee ${LOGFILE}

   touch $STATFILE
fi