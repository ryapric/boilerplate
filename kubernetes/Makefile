SHELL = /usr/bin/env bash

images = nginx fredcast

build:
	@for img in $(images); do \
		docker build -f ./$${img}/Dockerfile -t registry/user/$${img}:latest .; \
	done

push:
	@for img in $(images); do \
		docker push registry/user/$${img}:latest; \
	done

apply:
	@kubectl apply -f main.yaml

logs:
	@kubectl logs deployment/app --all-containers

delete:
	@kubectl delete -f main.yaml


##################################
# Minikube helpers for local dev #
##################################
minikube-push:
	@for img in $(images); do \
		printf "Caching $${img} to minikube...\n" \
		&& minikube cache add registry/user/$${img}:latest; \
	done
	@printf "Reloading minikube cache...\n" && minikube cache reload

minikube-apply:
	@minikube tunnel --cleanup
	@nohup minikube tunnel &
	@make -s apply

minikube-test:
	@curl $$(minikube service --url appservice)/api/health
