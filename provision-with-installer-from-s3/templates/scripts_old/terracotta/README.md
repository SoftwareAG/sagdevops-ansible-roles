## Terracotta

Once logged in on the server, become saguser:

```bash
sudo su - saguser
```

Then, run:

```bash
TARGET_DIR="/opt/softwareag/sag_install_artifacts"
mkdir -p $TARGET_DIR
aws s3 cp s3://softwareaggov-product-artifacts/customer_specifics/SSA/scripts/_common/download_helper.sh $TARGET_DIR
aws s3 cp s3://softwareaggov-product-artifacts/customer_specifics/SSA/scripts/terracotta/download.sh $TARGET_DIR
cd $TARGET_DIR
/bin/bash download.sh
export __installer_product_license="terracotta-license.key"
```

Once downloaded, run following 3 commands:

```bash
/bin/bash install_product.sh
```

```bash
/bin/bash install_sum.sh
```

```bash
/bin/bash install_fixes.sh
```