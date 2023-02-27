# ----------------------------------------------------------------------------
# Makefile for make4py
#
# Copyright (c) 2023 by Clemens Rabe <clemens.rabe@clemensrabe.de>
# All rights reserved.
# This file is part of make4py (https://github.com/seeraven/make4py)
# and is released under the "BSD 3-Clause License". Please see the LICENSE file
# that is included as part of this package.
# ----------------------------------------------------------------------------


# ----------------------------------------------------------------------------
#  DEFAULT SETTINGS
# ----------------------------------------------------------------------------
MAKE4PY_DIR            := $(dir $(lastword $(MAKEFILE_LIST)))
MAKE4PY_DIR_ABS        := $(abspath $(MAKE4PY_DIR))

UBUNTU_DIST_VERSIONS   := $(or $(UBUNTU_DIST_VERSIONS),18.04 20.04 22.04)
PYCODESTYLE_CONFIG     := $(or $(PYCODESTYLE_CONFIG),$(MAKE4PY_DIR)/.pycodestyle)
SRC_DIRS               := $(or $(SRC_DIRS),$(wildcard src/. test/.))


# ----------------------------------------------------------------------------
#  INCLUDE MODULES
# ----------------------------------------------------------------------------
include $(MAKE4PY_DIR)01_check_settings.mk
include $(MAKE4PY_DIR)02_platform_support.mk
include $(MAKE4PY_DIR)03_ensure_python_version.mk
include $(MAKE4PY_DIR)04_pip_dependency_pinning.mk
include $(MAKE4PY_DIR)05_system_setup.mk
include $(MAKE4PY_DIR)06_venv_support.mk
include $(MAKE4PY_DIR)07_multi_platform_docker.mk
include $(MAKE4PY_DIR)08_multi_platform_vagrant.mk
include $(MAKE4PY_DIR)09_check_style.mk
include $(MAKE4PY_DIR)10_unittests.mk
include $(MAKE4PY_DIR)12_documentation.mk


# ----------------------------------------------------------------------------
#  FUNCTIONS
# ----------------------------------------------------------------------------

# Recursive wildcard function. Call with: $(call rwildcard,<start dir>,<pattern>)
rwildcard = $(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))


# ----------------------------------------------------------------------------
#  SETTINGS
# ----------------------------------------------------------------------------

UBUNTU_RELEASE_TARGETS := $(addprefix releases/$(APP_NAME)_v$(APP_VERSION)_Ubuntu,$(addsuffix _amd64,$(UBUNTU_DIST_VERSIONS)))


# ----------------------------------------------------------------------------
#  USAGE
# ----------------------------------------------------------------------------
.PHONY: help

help:
	@echo "Makefile for $(APP_NAME) ($(APP_VERSION)):"
	@echo ""
	@echo "Target suffixes:"
	@echo " .ubuntuXX.YY              : Execute the make target in a docker"
	@echo "                             container running Ubuntu XX.YY. The"
	@echo "                             supported Ubuntu versions are $(UBUNTU_DIST_VERSIONS)"
	@echo " .windows                  : Execute the make target in a vagrant"
	@echo "                             box running Windows."
	@echo " .venv                     : Execute the make target in a virtual environment (venv)."
	@echo ""
	@echo " Multiple suffixes can be used that are processed from right to left, e.g.,"
	@echo " the target pip-deps-upgrade.venv.windows runs pip-deps-upgrade.venv in"
	@echo " a Windows vagrant box which in turn runs the target pip-deps-upgrade in"
	@echo " a venv."
	@echo ""
	@echo "Note: In the following, the targets are specified with the recommended"
	@echo "      environment."
	@echo ""
	@echo "Targets for PIP Dependency Pinning:"
	@echo " pip-deps-upgrade.venv     : Update the pip-dependencies extracted"
	@echo "                             from the pyproject.toml for the current"
	@echo "                             platform. The dependencies are stored in"
	@echo "                             $(PIP_DEPS_DIR)."
	@echo " pip-deps-upgrade-all      : Update the pip-dependencies in all"
	@echo "                             supported environments."
	@echo ""
	@echo "Targets for System Setup (used internally):"
	@echo " pip-setup                 : Install pip and pip-tools."
	@echo " pip-install-dev           : Install the dev pip-requirements."
	@echo " pip-upgrade-stuff         : Upgrade setuptools and wheel."
	@echo " system-setup              : Call all of the above targets."
	@echo ""
	@echo "Targets for Virtual Environment (venv):"
	@echo " venv                      : Setup the venv directory $(VENV_DIR)."
	@echo " venv-bash                 : Open a shell in the venv."
	@echo ""
ifeq ($(ON_WINDOWS),0)
	@echo "Targets for Cleanup:"
	@echo " clean-dockerimages        : Remove all generated docker images."
	@echo ""
	@echo "Targets for Windows Vagrant Box:"
	@echo " destroy-windows           : Destroy the vagrant box."
	@echo " update-windows-box        : Update the vagrant box."
	@echo " ssh-windows-box           : Enter a running vagrant box via ssh."
	@echo ""
endif
	@echo "Targets for Style Checking:"
	@echo " check-style.venv          : Call pylint, pycodestyle, flake8 and mypy."
	@echo " pylint.venv               : Call pylint on the source files."
	@echo " pycodestyle.venv          : Call pycodestyle on the source files."
	@echo " flake8.venv               : Call flake8 on the source files."
	@echo " mypy.venv                 : Call mypy on the source files."
	@echo ""
	@echo "Targets for Testing:"
	@echo " unittests.venv            : Execute the unittests."
	@echo ""
	@echo "Development Information:"
	@echo " PWD                = $(PWD)"
	@echo " CURDIR             = $(CURDIR)"
	@echo " MAKE4PY_DIR        = $(MAKE4PY_DIR)"
	@echo " MAKE4PY_DIR_ABS    = $(MAKE4PY_DIR_ABS)"


# ----------------------------------------------------------------------------
#  IPYTHON SUPPORT
# ----------------------------------------------------------------------------
.PHONY: ipython

ipython:
	@$(VENV_ACTIVATE_PLUS) \
	ipython


# ----------------------------------------------------------------------------
#  MAINTENANCE TARGETS
# ----------------------------------------------------------------------------

distclean: clean
	@$(call RMDIRR,releases)
	@$(call RMDIRR,.mypy_cache)

clean:
	@$(call RMDIR,$(VENV_DIR) dist build doc/build doc/*coverage doc/source/apidoc)
	@$(call RMFILE,.coverage .coverage-* *.spec)
	@$(call RMDIRR,__pycache__)
	@$(call RMFILER,*~)
	@$(call RMFILER,*.pyc)


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
