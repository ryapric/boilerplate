ifndef ENV
$(error You must pass an `ENV` variable on the CLI, e.g.: `make <target> ENV=<env>`. Aborting.)
endif

TFVARSFILE := $(ENV).tfvars

COMMON_ARGS := -var-file="./tfvars/$(TFVARSFILE)"

GET_IP = curl -sS http://icanhazip.com
WRITE_ARGS := -var="tf_host_ip=$$($(GET_IP))"

GET_IP = curl -sS http://icanhazip.com

init:
	@terraform init -backend-config="backends/$(TFVARSFILE)"

plan:
	@terraform plan $(COMMON_ARGS) $(WRITE_ARGS) -out="./out.tfplan"

apply:
	@terraform apply $(COMMON_ARGS) $(WRITE_ARGS)

# Still need WRITE_ARGS; even though it's not used here, it's passed by the
# caller
destroy:
	@terraform destroy $(COMMON_ARGS) $(WRITE_ARGS)
