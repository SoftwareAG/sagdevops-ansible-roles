#!/bin/sh

echo "Begin $0"

THIS=`basename $0`
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`

echo "current folder: $THISDIR"
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

if [ "x$__sum_install_path" == "x" ]; then
    __sum_install_path="/opt/sum"
fi

if [ "x$__sum_fix_target_path" == "x" ]; then
    __sum_fix_target_path="/opt/softwareag"
fi

if [ "x$__sum_fix_image" == "x" ]; then
    __sum_fix_image="sum_image.zip"
fi

if [ "x$__sum_fix_script" == "x" ]; then
    __sum_fix_script="sum.script"
fi

__sum_fix_image_path="${__work_dir}/${__sum_fix_image}"
__sum_fix_script_path="${__work_dir}/${__sum_fix_script}"

## replace values in the webMethods Installer script
replace_global "{{ __sum_fix_target_path }}" "${__sum_fix_target_path}" "$__sum_fix_script_path"
replace_global "{{ __sum_fix_image_path }}" "$__sum_fix_image_path" "$__sum_fix_script_path"

echo "target install dir: $__sum_fix_target_path"
ls -al $__sum_fix_target_path

## run update manager
echo "Running update manager"
/bin/sh ${__sum_install_path}/bin/UpdateManagerCMD.sh -readScript "$__sum_fix_script_path" -installFromImage "$__sum_fix_image_path" -imageFile "$__sum_fix_image_path"
echo "DONE!!"

## run update manager cleanup
echo "Running update manager cleanup"
/bin/sh ${__sum_install_path}/bin/UpdateManagerCMD.sh -readScript "$__sum_fix_script_path" -clearCache true
echo "DONE!!"