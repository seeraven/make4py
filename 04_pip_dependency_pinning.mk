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


# ----------------------------------------------------------------------------
#  TARGETS
# ----------------------------------------------------------------------------

# Targets to generate pip_deps requirements-files if they do not exist
$(PIP_REQUIREMENTS): pyproject.toml
	@$(call MKDIR,$(PIP_DEPS_DIR))
	@echo "-------------------------------------------------------------"
	@echo "Compile pip dependencies $(PIP_REQUIREMENTS)..."
	@echo "-------------------------------------------------------------"
	@pip-compile --resolver=backtracking pyproject.toml \
	    --output-file=$(PIP_REQUIREMENTS) \
	    --no-emit-trusted-host --no-emit-index-url --quiet

$(PIP_DEV_REQUIREMENTS): pyproject.toml
	@$(call MKDIR,$(PIP_DEPS_DIR))
	@echo "-------------------------------------------------------------"
	@echo "Compile pip dependencies $(PIP_DEV_REQUIREMENTS)..."
	@echo "-------------------------------------------------------------"
	@pip-compile --resolver=backtracking pyproject.toml \
	    --extra dev \
	    --extra test \
	    --output-file=$(PIP_DEV_REQUIREMENTS) \
	    --no-emit-trusted-host --no-emit-index-url --quiet

.PHONY: pip-deps-upgrade

pip-deps-upgrade:
	@$(call MKDIR,$(PIP_DEPS_DIR))
	@echo "-------------------------------------------------------------"
	@echo "Upgrade pip dependencies $(PIP_REQUIREMENTS) and $(PIP_DEV_REQUIREMENTS)..."
	@echo "-------------------------------------------------------------"
	@pip-compile --resolver=backtracking pyproject.toml \
	    --output-file=$(PIP_REQUIREMENTS) \
	    --no-emit-trusted-host --no-emit-index-url --quiet --upgrade
	@pip-compile --resolver=backtracking pyproject.toml \
	    --extra dev \
	    --extra test \
	    --output-file=$(PIP_DEV_REQUIREMENTS) \
	    --no-emit-trusted-host --no-emit-index-url --quiet --upgrade

ifeq ($(ON_WINDOWS),0)

PIP_DEPS_UPGRADE_DOCKER_TARGETS := $(addprefix pip-deps-upgrade.venv.ubuntu,$(UBUNTU_DIST_VERSIONS))

.PHONY: pip-deps-upgrade-all

pip-deps-upgrade-all: $(PIP_DEPS_UPGRADE_DOCKER_TARGETS) pip-deps-upgrade.venv.windows

else

.PHONY: pip-deps-upgrade-all

pip-deps-upgrade-all: pip-deps-upgrade.venv

endif


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
