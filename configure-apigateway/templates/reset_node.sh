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
find ${SAG_HOME} -name clusteruuid.dat -exec rm -rf {} \;
rm -Rf ${SAG_HOME}/IntegrationServer/instances/${INSTANCE_NAME}/logs/*
rm -Rf ${SAG_HOME}/profiles/IS_${INSTANCE_NAME}/logs/*
rm -Rf ${SAG_HOME}/profiles/SPM/logs/*
rm -Rf ${SAG_HOME}/profiles/IS_${INSTANCE_NAME}/logs/*
rm -Rf ${SAG_HOME}/InternalDataStore/logs/*
rm -Rf ${SAG_HOME}/install/logs/*

# update node
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

## Perform a folder/file replacement of old host to new?
replacePathsInFiles() {
   local search_pattern=$1;
   local replacement=$2;

   for file in `find ${SAG_HOME} -type f -exec grep -il "${search_pattern}" {} \; | grep -vE "\.log|\.jar"`
   do
      echo "update pattern ${search_pattern} in $file"
      sed -i "s!${search_pattern}!${replacement}!g" $file
   done
}

{% if search_pattern is defined and search_pattern != "" %}
replacePathsInFiles "{{ search_pattern }}" "{{ search_pattern_replacement }}"
{% endif %}

# install/etc/installconfig.prop:hostname=ip-172-40-192-143
# IntegrationServer/instances/default/packages/WmAssetPublisher/config/assetpublisher.cnf:    <value name="is_hostname">ip-172-40-192-143.ad.clouddemo.saggov.local</value>
# IntegrationServer/instances/default/config/security/openid/salesforce.com.json:  "redirection_endpoint_host" : "ip-172-40-192-143.ad.clouddemo.saggov.local",
# IntegrationServer/instances/default/config/remote.cnf:    <value name="host">ip-172-40-192-143.ad.clouddemo.saggov.local</value>
# IntegrationServer/instances/default/config/backup/security/openid/salesforce.com.json:  "redirection_endpoint_host" : "ip-172-40-192-143.ad.clouddemo.saggov.local",
# IntegrationServer/instances/default/config/backup/remote.cnf:    <value name="host">ip-172-40-192-143.ad.clouddemo.saggov.local</value>
# InternalDataStore/config/elasticsearch.yml:node.name: ip-172-40-192-1431613691068585
# InternalDataStore/config/elasticsearch.yml:cluster.initial_master_nodes: ["ip-172-40-192-1431613691068585"]
# InternalDataStore/config/elasticsearch.state.yml:node.name: ip-172-40-192-1431613691068585
# InternalDataStore/config/elasticsearch.state.yml:cluster.initial_master_nodes: ["ip-172-40-192-1431613691068585"]
