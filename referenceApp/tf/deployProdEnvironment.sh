#!/bin/bash

terraform workspace select prod || terraform workspace new prod


terraform plan -var-file _prod.tfvars