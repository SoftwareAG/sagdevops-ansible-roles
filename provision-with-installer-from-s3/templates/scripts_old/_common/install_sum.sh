#!/bin/sh

echo "Begin $0"

THIS=`basename $0`
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`

echo "current folder: $THISDIR"

## set params to default if not defined already (ie. env variables)
if [ "x$__work_dir" == "x" ]; then
    __work_dir="/opt/softwareag/sag_install_artifacts"
fi

if [ "x$__sum_install_target_path" == "x" ]; then
    __sum_install_target_path="/opt/sum"
fi

if [ "x$__sum_install_executable" == "x" ]; then
    __sum_install_executable="softwareagupdatemanager-linux.bin"
fi

if [ "x$__sum_fix_image" == "x" ]; then
    __sum_fix_image="sum_image.zip"
fi
__sum_fix_image_path="${__work_dir}/${__sum_fix_image}"

echo "target install dir: $__sum_install_target_path"
ls -al $__sum_install_target_path

## run installer
/bin/sh ${__sum_install_executable} --accept-license -d ${__sum_install_target_path} -i ${__sum_fix_image_path}

echo "target install dir: $__sum_install_target_path"
ls -al $__sum_install_target_path

echo DONE!!