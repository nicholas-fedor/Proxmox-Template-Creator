all: init fmt validate build

init:
	packer init ./packer

fmt:
	packer fmt ./packer

validate:
	packer validate ./packer

build:
	packer build ./packer