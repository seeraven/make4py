# ----------------------------------------------------------------------------
# Makefile part of make4py
#
# Copyright (c) 2023 by Clemens Rabe <clemens.rabe@clemensrabe.de>
# All rights reserved.
# This file is part of make4py (https://github.com/seeraven/make4py)
# and is released under the "BSD 3-Clause License". Please see the LICENSE file
# that is included as part of this package.
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
