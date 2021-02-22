#!/bin/bash

NODENAME=`cat /etc/hostname`
export SAG_HOME=/opt/softwareag
export JAVA_HOME=${SAG_HOME}/jvm/jvm
INSTANCE_NAME=default
STATFILE=/tmp/init_container
LOGFILE=${SAG_HOME}/IntegrationServer/instances/${INSTANCE_NAME}/logs/updateNode.log

# shutdown first
${SAG_HOME}/profiles/IS_${INSTANCE_NAME}/bin/shutdown.sh

# cleanup
rm -f ${SAG_HOME}/IntegrationServer/instances/${INSTANCE_NAME}/config/repository4.cnf
rm -Rf ${SAG_HOME}/IntegrationServer/instances/${INSTANCE_NAME}/logs/*
rm -Rf ${SAG_HOME}/profiles/IS_${INSTANCE_NAME}/logs/*
rm -Rf ${SAG_HOME}/profiles/SPM/logs/*
rm -Rf ${SAG_HOME}/install/logs/*

## reset osgi profile
cd ${SAG_HOME}/IntegrationServer/instances; ./is_instance.sh delete-osgi-profile -Dinstance.name=${INSTANCE_NAME}; ./is_instance.sh create-osgi-profile -Dinstance.name=${INSTANCE_NAME}

## TODO perform a folder/file replacement of old host to new
