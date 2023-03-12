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

VAGRANTFILE := $(MAKE4PY_DIR_ABS)/Vagrantfile.win

.PHONY: destroy-windows update-windows-box ssh-windows-box

%.windows:
	@echo "Entering windows environment..."
	@VAGRANT_VAGRANTFILE=$(VAGRANTFILE) vagrant up
	@VAGRANT_VAGRANTFILE=$(VAGRANTFILE) vagrant ssh -- make -C C:\\vagrant $*
	@VAGRANT_VAGRANTFILE=$(VAGRANTFILE) vagrant halt
	@echo "Leaving windows environment."


destroy-windows:
	@VAGRANT_VAGRANTFILE=$(VAGRANTFILE) vagrant destroy -f

update-windows-box: destroy-windows
	@VAGRANT_VAGRANTFILE=$(VAGRANTFILE) vagrant box update
	@VAGRANT_VAGRANTFILE=$(VAGRANTFILE) vagrant box prune --force --keep-active-boxes

ssh-windows-box:
	@VAGRANT_VAGRANTFILE=$(VAGRANTFILE) vagrant ssh

endif


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
