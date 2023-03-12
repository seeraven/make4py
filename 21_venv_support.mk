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
    VENV_DIR := $(BUILD_DIR)\venv_$(WIN_PLATFORM_STRING)
    VENV_ACTIVATE := $(VENV_DIR)\Scripts\activate.bat
    VENV_ACTIVATE_PLUS := $(VENV_ACTIVATE) &
    VENV_SHELL := cmd.exe /K $(VENV_ACTIVATE)
    INTERACTIVE_SHELL := cmd.exe
else
    VENV_DIR := $(BUILD_DIR)/venv_$(LINUX_PLATFORM_STRING)
    VENV_ACTIVATE := source $(VENV_DIR)/bin/activate
    VENV_ACTIVATE_PLUS := $(VENV_ACTIVATE);
    VENV_SHELL := $(VENV_ACTIVATE_PLUS) /bin/bash
    INTERACTIVE_SHELL := /bin/bash
endif


# ----------------------------------------------------------------------------
#  TARGETS
# ----------------------------------------------------------------------------

.PHONY: venv venv-bash ipython

$(VENV_DIR):
	@$(PYTHON) -m venv $(VENV_DIR)
	@$(VENV_ACTIVATE_PLUS) make system-setup
	@echo "-------------------------------------------------------------"
	@echo "Virtualenv venv setup. Call"
	@echo "  $(VENV_ACTIVATE)"
	@echo "to activate it."
	@echo "-------------------------------------------------------------"

venv: $(VENV_DIR)


ifeq ($(SWITCH_TO_VENV),1)
venv-bash: venv
	@echo "Entering a new shell using the venv setup:"
	@$(VENV_SHELL)
	@echo "Leaving sandbox shell."

ipython: venv
	@$(VENV_ACTIVATE_PLUS) \
	ipython
else
venv-bash:
	@echo "Opening a new subshell in the existing venv setup:"
	@$(INTERACTIVE_SHELL)
	@echo "Leaving subshell."

ipython:
	@ipython
endif


%.venv: venv
	@echo "Entering venv $(VENV_DIR):"
	@$(VENV_ACTIVATE_PLUS) make $*
	@echo "Leaving venv $(VENV_DIR)."


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
