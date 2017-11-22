
SYNC_DIR=/vagrant/
DEFAULT_PP=puppet/manifests/default.pp
CLEAN_PP=puppet/manifests/clean.pp
MODULES_PP=puppet/modules/


.PHONY: build pack destroy

build: Vagrantfile $(DEFAULT_PP)
	vagrant up
	@echo "Updating GuestAdditions to the new kernel"
	vagrant halt || true
	vagrant up
	vagrant halt || true

pack: Vagrantfile $(CLEAN_PP) $(MODULES_PP)
	@echo "Cleaning up and compress the box"
	vagrant up
	vagrant ssh -- "sudo puppet apply --modulepath=$(SYNC_DIR)/$(MODULES_PP) $(SYNC_DIR)/$(CLEAN_PP)"
	vagrant halt || true
	@echo "Packaging the box"
	vagrant package srv6

destroy: Vagrantfile
	vagrant destroy

