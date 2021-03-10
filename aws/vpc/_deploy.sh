#!/bin/sh

terraform fmt || { echo "Formatting failed"; exit 1; }
terraform validate || { echo "Validation failed"; exit 1; }

echo "Enter the AWS region to deploy to (us-west-1/eu-west-2): "
read region
terraform workspace select $region || { echo "Workspace selection failed"; exit 1; }

git diff
terraform apply || { echo "Apply failed"; exit 1; }
