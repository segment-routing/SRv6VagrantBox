
SYNC_DIR=/vagrant/
DEFAULT_PP=puppet/manifests/default.pp
CLEAN_PP=puppet/manifests/clean.pp
MODULES_PP=puppet/modules/
BOX=srv6.box
TEST_BOX_NAME="test/SRv6"


.PHONY: build pack clean test clean_test

build: clean Vagrantfile $(DEFAULT_PP)
	vagrant up
	@echo "Updating GuestAdditions to the new kernel"
	vagrant halt || true
	vagrant up
	vagrant halt || true

$(BOX): Vagrantfile $(CLEAN_PP) $(MODULES_PP)
	if vagrant status | grep -q "not created"; then \
		make; \
	fi
	@echo "Cleaning up and compress the box"
	vagrant up
	vagrant ssh -- "sudo puppet apply --modulepath=$(SYNC_DIR)/$(MODULES_PP) $(SYNC_DIR)/$(CLEAN_PP)"
	vagrant halt || true
	@echo "Packaging the box"
	rm -f $(BOX)
	vagrant package --output $(BOX)

pack:
	rm -f $(BOX)
	make $(BOX)

test: $(BOX) clean_test
	vagrant box add $(BOX) --name $(TEST_BOX_NAME)
	cd test && vagrant up
	cd test && vagrant ssh -- "sudo python $(SYNC_DIR)/run_tests.py"

clean_test:
	cd test && vagrant destroy -f
	vagrant box remove $(TEST_BOX_NAME) || true

clean: clean_test Vagrantfile test/Vagrantfile
	rm -f $(BOX)
	vagrant destroy -f
