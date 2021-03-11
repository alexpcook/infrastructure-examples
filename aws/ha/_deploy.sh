#!/bin/sh

terraform fmt || { echo "Formatting failed"; exit 1; }
terraform validate || { echo "Validation failed"; exit 1; }

echo "Enter the AWS region to deploy to (us-west-1): "
read region

if [ -z $region ]; then
    echo "Using default Terraform workspace"
else
    terraform workspace select $region || { echo "Workspace selection failed"; exit 1; }
fi

git diff
terraform apply || { echo "Apply failed"; exit 1; }
