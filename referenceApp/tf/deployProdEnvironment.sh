#!/bin/bash

terraform workspace select prod || terraform workspace new prod


terraform apply -var-file _prod.tfvars