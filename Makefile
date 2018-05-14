SHELL := /bin/bash

SYNC_DIR=/vagrant/
TEST_BOX_NAME=test/SRv6
LIBVIRT_VOL_NAME=test-VAGRANTSLASH-SRv6_vagrant_box_image_0.img

DISTRIBUTION=ubuntu-16.04
ARCH=amd64

PROVIDERS=virtualbox libvirt
BOX_MAPPING_DECL=declare -A BOX_MAPPING=([bento/builds/$(DISTRIBUTION).virtualbox.box]=virtualbox [bento/builds/$(DISTRIBUTION).libvirt.box]=libvirt)
BUILDER_MAPPING_DECL=declare -A BUILDER_MAPPING=([virtualbox]=virtualbox-iso [libvirt]=qemu)

PROVIDER_CLEANS=$(addsuffix .clean,$(PROVIDERS))
PROVIDER_TESTS=$(addsuffix .test,$(PROVIDERS))
PROVIDER_BOXES=$(addprefix bento/builds/$(DISTRIBUTION).,$(addsuffix .box,$(PROVIDERS)))

PUPPET=bento/ubuntu/puppet
SCRIPTS=bento/ubuntu/scripts

.PHONY: pack sync_scripts clean test clean_test

pack: SHELL:=/bin/bash
pack: sync_scripts $(PROVIDER_BOXES)

sync_scripts:
	cp -r puppet $(PUPPET)
	cp scripts/* $(SCRIPTS)
	cp $(DISTRIBUTION)-$(ARCH).json bento/ubuntu

$(PROVIDER_BOXES):
	@echo "Building box $@"
	$(BOX_MAPPING_DECL); \
		$(BUILDER_MAPPING_DECL); \
		echo "Using packer builder $${BUILDER_MAPPING[$${BOX_MAPPING[$@]}]}"; \
		cd bento/ubuntu && packer build -only=$${BUILDER_MAPPING[$${BOX_MAPPING[$@]}]} $(DISTRIBUTION)-$(ARCH).json

test: $(PROVIDER_TESTS)

%.test: bento/builds/$(DISTRIBUTION).%.box clean_test
	vagrant box add $< --name $(TEST_BOX_NAME) --provider $(basename $@)
	cd test && vagrant up --provider $(basename $@)
	cd test && vagrant ssh -- "sudo python $(SYNC_DIR)/run_tests.py"
	$(MAKE) clean_test

clean_test:
	cd test && vagrant destroy -f
	vagrant box remove $(TEST_BOX_NAME) || true
	virsh vol-delete $(LIBVIRT_VOL_NAME) --pool default || true
	sudo systemctl restart libvirtd

clean: clean_test
	rm -rf bento/builds/*

