#!/bin/bash

terraform workspace select devel || terraform workspace new devel

terraform apply -var-file _dev.tfvars