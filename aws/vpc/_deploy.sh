#!/bin/sh
terraform fmt || { echo "Formatting failed"; exit 1; }
terraform validate || { echo "Validation failed"; exit 1; }
git diff *.tf *.tfvars
terraform apply || { echo "Apply failed"; exit 1; }
