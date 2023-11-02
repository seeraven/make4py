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
    VALIDATE_PYPROJECT_VENV_DIR := $(BUILD_DIR)\venv_validate_pyproject_$(WIN_PLATFORM_STRING)$(PLATFORM_SUFFIX)
    VALIDATE_PYPROJECT_VENV_ACTIVATE := $(VALIDATE_PYPROJECT_VENV_DIR)\Scripts\activate.bat
    VALIDATE_PYPROJECT_VENV_ACTIVATE_PLUS := $(VALIDATE_PYPROJECT_VENV_ACTIVATE) &
else
    VALIDATE_PYPROJECT_VENV_DIR := $(BUILD_DIR)/venv_validate_pyproject_$(LINUX_PLATFORM_STRING)$(PLATFORM_SUFFIX)
    VALIDATE_PYPROJECT_VENV_ACTIVATE := source $(VALIDATE_PYPROJECT_VENV_DIR)/bin/activate
    VALIDATE_PYPROJECT_VENV_ACTIVATE_PLUS := $(VALIDATE_PYPROJECT_VENV_ACTIVATE);
endif


# ----------------------------------------------------------------------------
#  TARGETS
# ----------------------------------------------------------------------------

define create-validate-pyproject-venv =
$(call RMDIR,$(VALIDATE_PYPROJECT_VENV_DIR))
echo "-------------------------------------------------------------"
echo "Create $(VALIDATE_PYPROJECT_VENV_DIR)"
echo "-------------------------------------------------------------"
$(PYTHON) -m venv $(VALIDATE_PYPROJECT_VENV_DIR)
$(VALIDATE_PYPROJECT_VENV_ACTIVATE_PLUS) $(PYTHON) -m pip install --upgrade pip
$(VALIDATE_PYPROJECT_VENV_ACTIVATE_PLUS) pip install validate-pyproject[all]
endef


.PHONY: validate-pyproject-toml

validate-pyproject-toml:
	@$(create-validate-pyproject-venv)
	@$(VALIDATE_PYPROJECT_VENV_ACTIVATE_PLUS) validate-pyproject pyproject.toml
	@$(call RMDIR,$(VALIDATE_PYPROJECT_VENV_DIR))


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
