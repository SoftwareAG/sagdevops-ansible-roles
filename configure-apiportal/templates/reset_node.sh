#!/bin/bash

NODENAME=`cat /etc/hostname`
export SAG_HOME={{ webmethods_install_dir }}
export JAVA_HOME=${SAG_HOME}/jvm/jvm

# shutdown components first
if [ -f ${SAG_HOME}/API_Portal/server/stop_api.sh ]; then
    ${SAG_HOME}/API_Portal/server/stop_api.sh
fi

if [ -f ${SAG_HOME}/API_Portal/server/bin/CloudAgentApp.sh ]; then
    ${SAG_HOME}/API_Portal/server/bin/CloudAgentApp.sh stop
fi

# cleanup all runtime data from previous runs
rm -Rf ${SAG_HOME}/install/logs/*

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
