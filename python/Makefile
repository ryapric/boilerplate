# Name of package
PKGNAME := $$(grep 'name = ' setup.py | sed -r 's/name = '"'"'(.*)'"'"',/\1/')

# Need to adjust shell used, for `source` command
SHELL = /usr/bin/env bash

# Set venv activation, since make runs each recipe in its own shell instance
venv-act = source venv/bin/activate


all: venv dev-pkgs install_venv test clean

# Dummy FORCE target dep to make things always run
FORCE:

venv: FORCE
	@python3 -m venv --clear venv

dev-pkgs: venv
	@$(venv-act); \
	pip3 install wheel; \
	pip3 install setuptools pytest pytest-flask

test: clean venv dev-pkgs install_venv
	@$(venv-act); \
	python3 -m pytest -v # don't chain from here, so failed tests throw shell error code
	@make -s clean

build: venv dev-pkgs
	@$(venv-act); \
	python3 setup.py sdist bdist_wheel

install_venv: venv
	@$(venv-act); \
	pip3 install .

clean: FORCE
	@find . -type d -regextype posix-extended -regex ".*\.egg-info|.*cache.*" -exec rm -rf {} +
	@find . -type f -regextype posix-extended -regex ".*\.pyc" -exec rm {} +
	@find . -name "test.db" -exec rm {} +

# Install to system library
install: FORCE
ifeq ($(`whoami`), 'root')
	pip3 install .
else
	pip3 install --user .
endif

doc: FORCE
	@pandoc -o README.html README.md
	@echo "Created README.html"

uninstall: FORCE
	pip3 uninstall -y $(PKGNAME)


#################################
# --- Google Cloud deployment ---
#################################
PROJECT = fredcast
IMAGE = fredcast
TAG = latest
REPO = gcr.io/$(PROJECT)

docker-build:
	@docker build -t $(IMAGE):$(TAG) .

# docker-push: docker-build
# 	@docker tag $(IMAGE):$(TAG) $(REPO)/$(IMAGE):$(TAG)
# 	@docker push $(REPO)/$(IMAGE):$(TAG)

# Using local build tool, see how a Cloud Build would run
gcloud-build-local:
	@cloud-build-local --dryrun=false .

# Submit repo to Cloud Build, build based on config file
gcloud-builds-submit-config: clean
	@gcloud builds submit --config cloudbuild.yaml .
	@make -s gcloud-delete-untagged-images

# Sumbit repo to Cloud Build; build based on *Dockerfile*
# This is weaker than defining steps in a config file, which can *also* build an image
gcloud-builds-submit-image: clean
	@gcloud builds submit --tag gcr.io/$(PROJECT)/$(IMAGE) .
	@make -s gcloud-delete-untagged-images

# Delete untagged images from GCR, to save space and reduce clutter
# From `gcloud container images delete --help`
gcloud-delete-untagged-images:
	@digests=$$(gcloud container images list-tags gcr.io/fredcast/fredcast \
	    --filter='-tags:*' --format='get(digest)'); \
	for d in $$digests; do \
	    gcloud container images delete --quiet gcr.io/fredcast/fredcast@$$d; \
	done

# Launch brand new GCC instance, based on a GCR image
# Note that the $(IMAGE) expansion will be the name of the resulting instance
gcloud-instance-create: gcloud-builds-submit
	@gcloud compute instances create-with-container $(IMAGE) \
	--container-image $(REPO)/$(IMAGE):$(TAG) \
	--machine-type "f1-micro" \
	--tags=http-server,https-server

# Update that GCC instance with an updated image
gcloud-instance-update: gcloud-builds-submit
	@gcloud compute instances update-container $(IMAGE) \
	--container-image $(REPO)/$(IMAGE):$(TAG)
