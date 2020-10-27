#!/bin/sh

echo "Begin $0"
 
THIS=`basename $0`
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`
THIS_HOSTNAME=`hostname --long`

echo "Current hostname: $THIS_HOSTNAME"
echo "Current folder: $THISDIR"
ls -al $THISDIR

## load utils functions
function replace_global { 
    local pattern=$1;
    local replacement=$2;
    local file=$3;
    sed -i 's#'"$pattern"'#'"$replacement"'#g' $file
}

## set params to default if not defined already (ie. env variables)
if [ "x$__work_dir" == "x" ]; then
    __work_dir="/opt/softwareag/sag_install_artifacts"
fi

if [ "x$__installer_target_path" == "x" ]; then
    __installer_target_path="/opt/softwareag"
fi

if [ "x$__installer_executable" == "x" ]; then
    __installer_executable="softwareaginstaller-linux.bin"
fi

if [ "x$__installer_script" == "x" ]; then
    __installer_script="installer.script"
fi

if [ "x$__installer_product_image" == "x" ]; then
    __installer_product_image="installer_image.zip"
fi

if [ "x$__installer_product_license" == "x" ]; then
    __installer_product_license="installer_license.xml"
fi

## replace values in the webMethods Installer script
replace_global "{{ __installer_target_path }}" "${__installer_target_path}" "$__installer_script"
replace_global "{{ __installer_product_license }}" "${__work_dir}/${__installer_product_license}" "$__installer_script"
replace_global "{{ __installer_product_image }}" "${__work_dir}/${__installer_product_image}" "$__installer_script"
replace_global "{{ __installer_target_hostname }}" "$THIS_HOSTNAME" "$__installer_script"

echo "Before install - target install dir: $__installer_target_path"
ls -al $__installer_target_path

## run installer
/bin/sh ${__installer_executable} -scriptErrorInteract no -readScript ${__work_dir}/${__installer_script}

echo "After install - target install dir: $__installer_target_path"
ls -al $__installer_target_path

echo DONE!!