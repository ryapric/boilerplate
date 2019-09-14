DEV_ACCOUNT := dev
DEV_REGION := us-west-1
GET_IP = curl -sS http://icanhazip.com

all: tf-apply

tf-apply:
	@terraform apply \
		-var="tf_host_ip=$$($(GET_IP))"

tf-destroy:
	@terraform destroy

tf-apply-dev:
	@terraform apply \
		-var='region=$(DEV_REGION)' \
		-var='default_tags={"Name":"Ryan Price","Email":"ryapric@gmail.com"}' \
		-var="tf_host_ip=$$($(GET_IP))" \
		-var='app_instance_nametag=terraform_ryapric'

tf-destroy-dev:
	@terraform destroy \
		-var='region=$(DEV_REGION)'
