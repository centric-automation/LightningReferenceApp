#!/bin/bash

terraform workspace select test || terraform workspace new test


terraform apply -var-file _test.tfvars