SHELL = /usr/bin/env bash

# This will require that the environment name be passed in for all targets
ifndef ENV
$(error You must pass an `ENV` variable on the CLI, e.g.: `make <target> ENV=<env>`. Aborting.)
endif

# Set the .tfvars file based on the ENV var
TFVARSFILE := $(ENV).tfvars

# Common arguments passed to all targets
COMMON_ARGS := -var-file="./tfvars/$(TFVARSFILE)"

# This fetches the deployment host IP (like your laptop), to be used in the AWS
# Security Group rules in the config
GET_IP = curl -sS http://icanhazip.com
CREATE_ARGS := -var="tf_host_ip=$$($(GET_IP))"

# Additional resource targeting, if supplied. VPC module is always called
# regardless of what is supplied here -- therefore, if you do not supply a
# `TARGET` arg to Make, the only resources created will be VPC resources from
# the `aws_vpc` module.
ifdef TARGET
TARGETARG = "-target=$(TARGET)"
else
TARGET = ""
endif

# This target also expects an env name to pull the right backend config
# dynamically. For local state only (no backend), just run `terraform init`
# without calling this target.
init:
	@terraform init \
		-backend-config="backends/$(TFVARSFILE)"

plan:
	@terraform plan \
		$(COMMON_ARGS) \
		$(CREATE_ARGS) \
		-target=module.aws_vpc \
		$(TARGETARG)

apply:
	@terraform apply \
		$(COMMON_ARGS) \
		$(CREATE_ARGS) \
		-target=module.aws_vpc \
		$(TARGETARG)

destroy:
	@terraform destroy \
		$(COMMON_ARGS) \
		-target=module.aws_vpc \
		$(TARGETARG)
