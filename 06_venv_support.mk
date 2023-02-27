# ----------------------------------------------------------------------------
# Makefile part of make4py
#
# Copyright (c) 2023 by Clemens Rabe <clemens.rabe@clemensrabe.de>
# All rights reserved.
# This file is part of make4py (https://github.com/seeraven/make4py)
# and is released under the "BSD 3-Clause License". Please see the LICENSE file
# that is included as part of this package.
# ----------------------------------------------------------------------------


# ----------------------------------------------------------------------------
#  SETTINGS
# ----------------------------------------------------------------------------

ifeq ($(ON_WINDOWS),1)
    VENV_DIR := venv_$(WIN_PLATFORM_STRING)
    VENV_ACTIVATE := $(VENV_DIR)\Scripts\activate.bat
    VENV_ACTIVATE_PLUS := $(VENV_ACTIVATE) &
    VENV_SHELL := cmd.exe /K $(VENV_ACTIVATE)
else
    ifeq (, $(shell which lsb_release))
        VENV_DIR := venv
    else
        VENV_DIR := venv_$(shell lsb_release -i -s)$(shell lsb_release -r -s)
    endif
    VENV_ACTIVATE := source $(VENV_DIR)/bin/activate
    VENV_ACTIVATE_PLUS := $(VENV_ACTIVATE);
    VENV_SHELL := $(VENV_ACTIVATE_PLUS) /bin/bash
endif


# ----------------------------------------------------------------------------
#  TARGETS
# ----------------------------------------------------------------------------

.PHONY: venv venv-bash

$(VENV_DIR):
	@$(PYTHON) -m venv $(VENV_DIR)
	@$(VENV_ACTIVATE_PLUS) make system-setup
	@echo "-------------------------------------------------------------"
	@echo "Virtualenv venv setup. Call"
	@echo "  $(VENV_ACTIVATE)"
	@echo "to activate it."
	@echo "-------------------------------------------------------------"

venv: $(VENV_DIR)

venv-bash: venv
	@echo "Entering a new shell using the venv setup:"
	@$(VENV_SHELL)
	@echo "Leaving sandbox shell."


%.venv: venv
	$(VENV_ACTIVATE_PLUS) make $*


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
