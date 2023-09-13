include .env

TIMESTAMP := $(shell date +'%Y%m%d-%H%M%S')
VERSION	  := $(shell git rev-parse --short HEAD)
ZIP_FILE  := $(PROJECT)-$(VERSION)-$(TIMESTAMP).zip

TERRAFORM_ARGS := \
	-var profile=$(AWS_PROFILE) \
	-var region=$(AWS_REGION) \
	-var project=$(PROJECT) \
	-var zip_file=$(ZIP_FILE)

.PHONY: venv build init plan apply destroy

all: build init apply

lambda/venv/.lock: lambda/requirements.txt
	test -d lambda/venv || virtualenv -p python3 lambda/venv
	. lambda/venv/bin/activate; pip install -Ur lambda/requirements.txt
	touch lambda/venv/.lock

venv: lambda/venv/.lock

build: venv
	mkdir -p build
	cd lambda && zip -r ../build/$(ZIP_FILE) .

init:
	cd terraform && terraform init $(TERRAFORM_ARGS)

plan:
	cd terraform && terraform plan $(TERRAFORM_ARGS)

apply:
	cd terraform && terraform apply $(TERRAFORM_ARGS)

destroy:
	cd terraform && terraform destroy $(TERRAFORM_ARGS)

