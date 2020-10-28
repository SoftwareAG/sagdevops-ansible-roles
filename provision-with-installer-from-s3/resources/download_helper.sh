#!/bin/sh

#############################################################################################
######## generic downlaad
#############################################################################################

function download_artifacts { 
    if [ "x$REMOTE_S3_BUCKET" == "x" ]; then
        echo "[ERROR!! REMOTE_S3_BUCKET env is not set ]"
        exit 2;
    fi 

    S3_BASE_URL=""
    if [ "x$REMOTE_S3_BUCKET_PREFIX" == "x" ]; then
        S3_BASE_URL="s3://${REMOTE_S3_BUCKET}"
    else
        S3_BASE_URL="s3://${REMOTE_S3_BUCKET}/${REMOTE_S3_BUCKET_PREFIX}"
    fi
    echo "Download artifacts from S3 with S3_BASE_URL=$S3_BASE_URL"

    ## installers
    if [ ! -f $LOCAL_PRODUCT_INSTALLER ]; then
        aws s3 cp ${S3_BASE_URL}/${REMOTE_S3_BUCKET_PRODUCT_INSTALLER} $LOCAL_PRODUCT_INSTALLER
    else
        echo "$LOCAL_PRODUCT_INSTALLER already downloaded...not downloading again."
    fi

    if [ ! -f $LOCAL_PRODUCTUPDATES_INSTALLER ]; then
        aws s3 cp ${S3_BASE_URL}/${REMOTE_S3_BUCKET_PRODUCTUPDATES_INSTALLER} $LOCAL_PRODUCTUPDATES_INSTALLER
    else
        echo "$LOCAL_PRODUCTUPDATES_INSTALLER already downloaded...not downloading again."
    fi

    ## licenses
    if [ ! -f $LOCAL_LICENSE_ZIP ]; then
        aws s3 cp ${S3_BASE_URL}/${REMOTE_S3_BUCKET_LICENSES} $LOCAL_LICENSE_ZIP
        mkdir -p $LOCAL_TARGET_DIR/licenses/
        unzip $LOCAL_LICENSE_ZIP -d $LOCAL_TARGET_DIR/licenses/

        cp "$LOCAL_TARGET_DIR/licenses/$REMOTE_S3_BUCKET_INZIP_LICENSE_PATH" $LOCAL_LICENSE_PATH
    else
        echo "$LOCAL_LICENSE_ZIP already downloaded...not downloading again."
    fi

    ## install product image / script
    if [ ! -f $LOCAL_PRODUCT_SCRIPT ]; then
        aws s3 cp ${S3_BASE_URL}/${REMOTE_S3_BUCKET_PRODUCT_SCRIPT} $LOCAL_PRODUCT_SCRIPT
    else
        echo "$LOCAL_PRODUCT_SCRIPT already downloaded...not downloading again."
    fi

    if [ ! -f $LOCAL_PRODUCT_IMAGE ]; then
        aws s3 cp ${S3_BASE_URL}/${REMOTE_S3_BUCKET_PRODUCT_IMAGE} $LOCAL_PRODUCT_IMAGE
    else
        echo "$LOCAL_PRODUCT_IMAGE already downloaded...not downloading again."
    fi

    ## install fix image / script
    if [ ! -f $LOCAL_FIX_SCRIPT ]; then
        aws s3 cp ${S3_BASE_URL}/${REMOTE_S3_BUCKET_FIX_SCRIPT} $LOCAL_FIX_SCRIPT
    else
        echo "$LOCAL_FIX_SCRIPT already downloaded...not downloading again."
    fi

    if [ ! -f $LOCAL_FIX_IMAGE ]; then
        aws s3 cp ${S3_BASE_URL}/${REMOTE_S3_BUCKET_FIX_IMAGE} $LOCAL_FIX_IMAGE
    else
        echo "$LOCAL_FIX_IMAGE already downloaded...not downloading again."
    fi
}