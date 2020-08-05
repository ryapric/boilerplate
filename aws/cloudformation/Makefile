# CloudFormation CLI is super verbose, so this is nice to have

SHELL = /usr/bin/env bash


# This is identical for create- and update-stack, so stuff into a Make variable
define cfn-create-update-args
--stack-name $(stackname) \
--template-body file://stacks/$(stackname).yaml \
--parameters file://parameters/$(stackname)_dev.json \
--tags file://tags/$(env).json \
--capabilities CAPABILITY_IAM
endef


check-variables:
	@if [ -z $${stackname} ]; then \
		printf "You must supply a 'stackname' environment variable. Aborting.\n" && exit 1; \
	fi
	@if [ -z $${env} ]; then \
		printf "You must supply an 'env' environment variable. Aborting.\n" && exit 1; \
	fi

create: check-variables
	@printf "Trying to submit stack...\n"
	@aws cloudformation create-stack $(cfn-create-update-args)
	@printf "Stack submitted. Waiting for create completion...\n"
	@aws cloudformation wait stack-create-complete --stack-name $(stackname) || make -s cfn-delete stackname=$(stackname)
	@printf "Done.\n"

update: check-variables
	@printf "Trying to submit stack...\n"
	@aws cloudformation update-stack $(cfn-create-update-args)
	@printf "Stack submitted. Waiting for update completion...\n"
	@aws cloudformation wait stack-update-complete --stack-name $(stackname)
	@printf "Done.\n"

delete: check-variables
	@aws cloudformation delete-stack --stack-name $(stackname)
	@printf "Stack delete request sent. Waiting for delete completion...\n"
	@aws cloudformation wait stack-delete-complete --stack-name $(stackname)
	@printf "Done.\n"
