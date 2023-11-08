# ----------------------------------------------------------------------------
# Makefile part of make4py
#
# Copyright (c) 2023 by Clemens Rabe <clemens.rabe@clemensrabe.de>
# All rights reserved.
# This file is part of make4py (https://github.com/seeraven/make4py)
# and is released under the "BSD 3-Clause License". Please see the LICENSE file
# that is included as part of this package.
# ----------------------------------------------------------------------------


ifeq ($(ON_WINDOWS),0)
ifeq ($(ENABLE_WINDOWS_SUPPORT),1)

VAGRANTFILE   := $(or $(VAGRANTFILE),$(MAKE4PY_DIR_ABS)/Vagrantfile.win)
PROPAGATE_CMD := $(foreach VAR_NAME,$(VARS_TO_PROPAGATE),set $(VAR_NAME)="$($(VAR_NAME))" \&)

.PHONY: destroy-windows update-windows-box start-windows-box ssh-windows-box

%.windows:
	@echo "Entering windows environment..."
	@VAGRANT_VAGRANTFILE=$(VAGRANTFILE) vagrant up
	@VAGRANT_VAGRANTFILE=$(VAGRANTFILE) vagrant ssh -- $(PROPAGATE_CMD) make -C C:\\vagrant $*
	@VAGRANT_VAGRANTFILE=$(VAGRANTFILE) vagrant halt
	@echo "Leaving windows environment."


destroy-windows:
	@VAGRANT_VAGRANTFILE=$(VAGRANTFILE) vagrant destroy -f

update-windows-box: destroy-windows
	@VAGRANT_VAGRANTFILE=$(VAGRANTFILE) vagrant box update
	@VAGRANT_VAGRANTFILE=$(VAGRANTFILE) vagrant box prune --force --keep-active-boxes

start-windows-box:
	@VAGRANT_VAGRANTFILE=$(VAGRANTFILE) vagrant up

ssh-windows-box:
	@VAGRANT_VAGRANTFILE=$(VAGRANTFILE) vagrant ssh

endif
endif


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
