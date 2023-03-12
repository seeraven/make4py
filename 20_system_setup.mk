# ----------------------------------------------------------------------------
# Makefile part of make4py
#
# Copyright (c) 2023 by Clemens Rabe <clemens.rabe@clemensrabe.de>
# All rights reserved.
# This file is part of make4py (https://github.com/seeraven/make4py)
# and is released under the "BSD 3-Clause License". Please see the LICENSE file
# that is included as part of this package.
# ----------------------------------------------------------------------------


.PHONY: pip-setup pip-install-dev pip-upgrade-stuff system-setup

pip-setup:
	@echo "-------------------------------------------------------------"
	@echo "Installing pip..."
	@echo "-------------------------------------------------------------"
# Note: pip install -U pip had problems running on Windows, so we use now:
	@$(PYTHON) -m pip install --upgrade pip

pip-install-dev: $(PIP_DEV_REQUIREMENTS)
	@echo "-------------------------------------------------------------"
	@echo "Installing package requirements (development)..."
	@echo "-------------------------------------------------------------"
	@pip install -r $(PIP_DEV_REQUIREMENTS)

pip-upgrade-stuff:
	@echo "-------------------------------------------------------------"
	@echo "Upgrade setuptools and wheel..."
	@echo "-------------------------------------------------------------"
	@pip install --upgrade setuptools wheel

system-setup: pip-setup pip-install-dev pip-upgrade-stuff


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
