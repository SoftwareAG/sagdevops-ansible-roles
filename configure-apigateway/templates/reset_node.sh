#!/bin/bash

NODENAME=`cat /etc/hostname`
export SAG_HOME=/opt/softwareag
export JAVA_HOME=${SAG_HOME}/jvm/jvm
INSTANCE_NAME=default
STATFILE=/tmp/init_container
LOGFILE=${SAG_HOME}/IntegrationServer/instances/${INSTANCE_NAME}/logs/updateNode.log

# shutdown components first
if [ -f ${SAG_HOME}/profiles/IS_${INSTANCE_NAME}/bin/shutdown.sh ]; then
    ${SAG_HOME}/profiles/IS_${INSTANCE_NAME}/bin/shutdown.sh
fi

if [ -f ${SAG_HOME}/InternalDataStore/bin/shutdown.sh ]; then
    ${SAG_HOME}/InternalDataStore/bin/shutdown.sh
fi

# cleanup all runtime data from previous runs
rm -Rf ${SAG_HOME}/install/logs/*
rm -Rf ${SAG_HOME}/IntegrationServer/instances/logs/*
rm -f ${SAG_HOME}/IntegrationServer/instances/${INSTANCE_NAME}/config/repository4.cnf
rm -Rf ${SAG_HOME}/IntegrationServer/instances/${INSTANCE_NAME}/logs/*
rm -Rf ${SAG_HOME}/profiles/IS_${INSTANCE_NAME}/logs/*
rm -Rf ${SAG_HOME}/profiles/SPM/logs/*
rm -Rf ${SAG_HOME}/profiles/IS_${INSTANCE_NAME}/logs/*

# cleanup local elastic search
find ${SAG_HOME} -name clusteruuid.dat -exec rm -rf {} \;
rm -Rf ${SAG_HOME}/InternalDataStore/data/*
rm -Rf ${SAG_HOME}/InternalDataStore/logs/*

# update external properties
if [ ! -d "${SAG_HOME}/IntegrationServer/instances/${INSTANCE_NAME}/logs" ]
then
    mkdir "${SAG_HOME}/IntegrationServer/instances/${INSTANCE_NAME}/logs"
fi
touch $LOGFILE
if [ -f $STATFILE ]
then
   echo "Already ran node update"
else
   ${JAVA_HOME}/bin/java -cp ${SAG_HOME}/IntegrationServer/instances/${INSTANCE_NAME}/packages/WmAPIGateway/bin/lib/apigateway-tools.jar com.softwareag.apigateway.tools.docker.ModifyExternalProperties ${INSTANCE_NAME} | tee ${LOGFILE}
   touch $STATFILE
fi

## Perform a folder/file replacement of old host to new
replacePatternInFiles() {
   local pattern=$1;
   local replacement=$2;

   for file in `find ${SAG_HOME} -type f -exec grep -il "${pattern}" {} \; | grep -vE "\.log|\.jar|\.cfs|\.bak"`
   do
      echo "update pattern ${pattern} in ${file}"
      sed -i 's#'"${pattern}"'#'"${replacement}"'#g' ${file}
   done
}

NEW_HOSTNAME="{{ replacement_hostname_pattern | default() }}"
if [ "x${NEW_HOSTNAME}" == "x" ]; then
    NEW_HOSTNAME="${NODENAME}"
fi

{% if search_hostname_pattern is defined and search_hostname_pattern != "" %}
replacePatternInFiles "{{ search_hostname_pattern }}" "${NEW_HOSTNAME}"
{% endif %}