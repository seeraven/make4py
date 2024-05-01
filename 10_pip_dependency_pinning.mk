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
PIP_ENV_ID           := $(shell $(PYTHON) -c "import sys;print(f'{sys.platform}-py{sys.version_info[0]}.{sys.version_info[1]}.{sys.version_info[2]}',end='')")
PIP_DEPS_DIR         := $(or $(PIP_DEPS_DIR),$(CURDIR)/pip_deps)
PIP_REQUIREMENTS     := $(PIP_DEPS_DIR)/requirements-$(PIP_ENV_ID).txt
PIP_DEV_REQUIREMENTS := $(PIP_DEPS_DIR)/dev_requirements-$(PIP_ENV_ID).txt

ifeq ($(ON_WINDOWS),1)
    PIP_DEPS_VENV_DIR := $(BUILD_DIR)\venv_pipdeps_$(WIN_PLATFORM_STRING)$(PLATFORM_SUFFIX)
    PIP_DEPS_VENV_ACTIVATE := $(PIP_DEPS_VENV_DIR)\Scripts\activate.bat
    PIP_DEPS_VENV_ACTIVATE_PLUS := $(PIP_DEPS_VENV_ACTIVATE) &
else
    PIP_DEPS_VENV_DIR := $(BUILD_DIR)/venv_pipdeps_$(LINUX_PLATFORM_STRING)$(PLATFORM_SUFFIX)
    PIP_DEPS_VENV_ACTIVATE := source $(PIP_DEPS_VENV_DIR)/bin/activate
    PIP_DEPS_VENV_ACTIVATE_PLUS := $(PIP_DEPS_VENV_ACTIVATE);
endif


# ----------------------------------------------------------------------------
#  TARGETS
# ----------------------------------------------------------------------------

define create-pip-deps-venv
$(call RMDIR,$(PIP_DEPS_VENV_DIR))
echo "-------------------------------------------------------------"
echo "Create $(PIP_DEPS_VENV_DIR)"
echo "-------------------------------------------------------------"
$(PYTHON) -m venv $(PIP_DEPS_VENV_DIR)
$(PIP_DEPS_VENV_ACTIVATE_PLUS) $(PYTHON) -m pip install --upgrade pip
$(PIP_DEPS_VENV_ACTIVATE_PLUS) pip install pip-tools
endef


# Targets to generate pip_deps requirements-files if they do not exist
$(PIP_REQUIREMENTS): pyproject.toml
	@$(call MKDIR,$(PIP_DEPS_DIR))
	@$(create-pip-deps-venv)
	@echo "-------------------------------------------------------------"
	@echo "Compile pip dependencies $(PIP_REQUIREMENTS)..."
	@echo "-------------------------------------------------------------"
	@$(PIP_DEPS_VENV_ACTIVATE_PLUS) pip-compile pyproject.toml \
	    --resolver=backtracking \
	    --output-file=$(PIP_REQUIREMENTS) \
	    --no-emit-trusted-host --no-emit-index-url --no-header --no-strip-extras --quiet
	@$(call RMDIR,$(PIP_DEPS_VENV_DIR))

$(PIP_DEV_REQUIREMENTS): pyproject.toml
	@$(call MKDIR,$(PIP_DEPS_DIR))
	@$(create-pip-deps-venv)
	@echo "-------------------------------------------------------------"
	@echo "Compile pip dependencies $(PIP_DEV_REQUIREMENTS)..."
	@echo "-------------------------------------------------------------"
	@$(PIP_DEPS_VENV_ACTIVATE_PLUS) pip-compile pyproject.toml \
	    --resolver=backtracking \
	    --extra dev \
	    --extra test \
	    --output-file=$(PIP_DEV_REQUIREMENTS) \
	    --no-emit-trusted-host --no-emit-index-url --no-header --no-strip-extras --quiet
	@$(call RMDIR,$(PIP_DEPS_VENV_DIR))

.PHONY: pip-deps-upgrade

pip-deps-upgrade:
	@$(call MKDIR,$(PIP_DEPS_DIR))
	@$(create-pip-deps-venv)
	@echo "-------------------------------------------------------------"
	@echo "Upgrade pip dependencies $(PIP_REQUIREMENTS) and $(PIP_DEV_REQUIREMENTS)..."
	@echo "-------------------------------------------------------------"
	@$(PIP_DEPS_VENV_ACTIVATE_PLUS) pip-compile pyproject.toml \
	    --resolver=backtracking \
	    --output-file=$(PIP_REQUIREMENTS) \
	    --no-emit-trusted-host --no-emit-index-url --no-header --no-strip-extras --quiet --upgrade
	@$(PIP_DEPS_VENV_ACTIVATE_PLUS) pip-compile pyproject.toml \
	    --resolver=backtracking \
	    --extra dev \
	    --extra test \
	    --output-file=$(PIP_DEV_REQUIREMENTS) \
	    --no-emit-trusted-host --no-emit-index-url --no-header --no-strip-extras --quiet --upgrade
	@$(call RMDIR,$(PIP_DEPS_VENV_DIR))

ifeq ($(ON_WINDOWS),0)

PIP_DEPS_UPGRADE_DOCKER_TARGETS := $(addprefix pip-deps-upgrade.ubuntu,$(UBUNTU_DIST_VERSIONS))

.PHONY: pip-deps-upgrade-all

ifeq ($(ENABLE_WINDOWS_SUPPORT),1)
pip-deps-upgrade-all: $(PIP_DEPS_UPGRADE_DOCKER_TARGETS) pip-deps-upgrade.windows
else
pip-deps-upgrade-all: $(PIP_DEPS_UPGRADE_DOCKER_TARGETS)
endif

else

.PHONY: pip-deps-upgrade-all

pip-deps-upgrade-all: pip-deps-upgrade

endif


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
