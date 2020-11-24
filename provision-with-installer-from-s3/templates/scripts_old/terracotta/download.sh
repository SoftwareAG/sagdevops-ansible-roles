#!/bin/sh

#############################################################################################
######## parameter section that changes from products to products
#############################################################################################

LOCAL_TARGET_DIR="/opt/softwareag/sag_install_artifacts"
REMOTE_S3_BUCKET_SCRIPT_FOLDER="scripts/terracotta"

## installers
REMOTE_S3_BUCKET_PRODUCT_INSTALLER="SoftwareAGInstaller20191216-Linux-x86.bin"
LOCAL_PRODUCT_INSTALLER="$LOCAL_TARGET_DIR/softwareaginstaller-linux.bin"
REMOTE_S3_BUCKET_PRODUCTUPDATES_INSTALLER="SoftwareAGUpdateManagerInstaller-11-20200623-Linux-x86.bin"
LOCAL_PRODUCTUPDATES_INSTALLER="$LOCAL_TARGET_DIR/softwareagupdatemanager-linux.bin"

## licenses
REMOTE_S3_BUCKET_LICENSES="SSA_2068809.zip"
LOCAL_LICENSE_ZIP="$LOCAL_TARGET_DIR/licenses.zip"
REMOTE_S3_BUCKET_INZIP_LICENSE_PATH="TC Clustering/terracotta-license.key"
LOCAL_LICENSE_PATH="$LOCAL_TARGET_DIR/terracotta-license.key"

## products
REMOTE_S3_BUCKET_PRODUCT_IMAGE="LinuxImage105All.zip"
LOCAL_PRODUCT_IMAGE="$LOCAL_TARGET_DIR/installer_image.zip"
REMOTE_S3_BUCKET_PRODUCT_SCRIPT="${REMOTE_S3_BUCKET_SCRIPT_FOLDER}/TerracottaBigMemory43Install.script"
LOCAL_PRODUCT_SCRIPT="$LOCAL_TARGET_DIR/installer.script"

## fixes
REMOTE_S3_BUCKET_FIX_IMAGE="20200526-SSA-wMAPIMgt-Fixes.zip"
LOCAL_FIX_IMAGE="$LOCAL_TARGET_DIR/sum_image.zip"
REMOTE_S3_BUCKET_FIX_SCRIPT="${REMOTE_S3_BUCKET_SCRIPT_FOLDER}/TerracottaBigMemory43Update.script"
LOCAL_FIX_SCRIPT="$LOCAL_TARGET_DIR/sum.script"

#############################################################################################
######## generic download section
#############################################################################################

THIS=`basename $0`
THISDIR=`dirname $0`; THISDIR=`cd $THISDIR;pwd`

# make sure the download helper is here
if [ ! -f $THISDIR/download_helper.sh ]; then
    echo "[ERROR!! Script file $THISDIR/download_helper.sh not found... we need it to download artifacts ]"
    exit 2;
else
    . $THISDIR/download_helper.sh
fi

## execute download
download_artifacts

echo "DONE!!!"