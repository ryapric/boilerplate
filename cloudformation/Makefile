# CloudFormation CLI is super verbose, so this is nice to have

ifndef stackname
$(error You must provide a `stackname` paramter, e.g. `make create stackname=<x>`)
endif

# This is identical for create- and update-stack, so stuff into a Make variable
define cfn-create-update-args
--stack-name $(stackname) \
--template-body file://stacks/$(stackname).yaml \
--parameters file://parameters/$(stackname)_dev.json \
--tags file://tags/$(env).json
endef

create:
	@aws cloudformation create-stack $(cfn-create-update-args)

status:
	@aws cloudformation describe-stack-events --stack-name $(stackname)

update:
	@aws cloudformation update-stack $(cfn-create-update-args)

delete:
	@aws cloudformation delete-stack --stack-name $(stackname)
