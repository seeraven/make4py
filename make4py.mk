# ----------------------------------------------------------------------------
# Makefile for make4py
#
# Copyright (c) 2023 by Clemens Rabe <clemens.rabe@clemensrabe.de>
# All rights reserved.
# This file is part of syncer (https://github.com/seeraven/make4py)
# and is released under the "BSD 3-Clause License". Please see the LICENSE file
# that is included as part of this package.
# ----------------------------------------------------------------------------


# ----------------------------------------------------------------------------
#  OS Detection
# ----------------------------------------------------------------------------
ifdef OS
    ON_WINDOWS = 1
else
    ON_WINDOWS = 0
endif


# ----------------------------------------------------------------------------
#  FUNCTIONS
# ----------------------------------------------------------------------------

# Recursive wildcard function. Call with: $(call rwildcard,<start dir>,<pattern>)
rwildcard = $(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))


# ----------------------------------------------------------------------------
#  SETTINGS
# ----------------------------------------------------------------------------
UBUNTU_RELEASE_TARGETS := $(addprefix releases/$(APP_NAME)_v$(APP_VERSION)_Ubuntu,$(addsuffix _amd64,$(UBUNTU_DIST_VERSIONS)))
UBUNTU_PIPDEPS_TARGETS := $(addprefix pip-deps-upgrade-Ubuntu,$(addsuffix _amd64,$(UBUNTU_DIST_VERSIONS)))

ifeq ($(ON_WINDOWS),1)
    PWD             := $(CURDIR)
endif

MAKE4PY_DIR         := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

SHELL                = /bin/bash
PYLINT_RCFILE       := $(or $(PYLINT_RCFILE),$(MAKE4PY_DIR)/.pylintrc)
PYCODESTYLE_CONFIG  := $(or $(PYCODESTYLE_CONFIG),$(MAKE4PY_DIR)/.pycodestyle)


# ----------------------------------------------------------------------------
#  USAGE
# ----------------------------------------------------------------------------
help:
	@echo "Makefile for $(APP_NAME) ($(APP_VERSION)):"
	@echo ""
	@echo "Note: All targets can be executed in a virtual environment (venv)"
	@echo "      by using the '.venv' suffix."
	@echo "      For example, use the target 'check-style.venv' to perform"
	@echo "      the style checking in a virtual environment."
	@echo "      In the following, the targets are specified with the recommended"
	@echo "      environment."
	@echo ""
	@echo "Targets for Style Checking:"
	@echo " check-style.venv          : Call pylint, pycodestyle and flake8"
	@echo " pylint.venv               : Call pylint on the source files."
	@echo " pycodestyle.venv          : Call pycodestyle on the source files."
	@echo " flake8.venv               : Call flake8 on the source files."
	@echo " mypy.venv                 : Call mypy on the source files."
	@echo ""
	@echo "Development Information:"
	@echo " PWD                = $(PWD)"
	@echo " CURDIR             = $(CURDIR)"
	@echo " MAKE4PY_DIR        = $(MAKE4PY_DIR)"
	@echo " PYLINT_RCFILE      = $(PYLINT_RCFILE)"
	@echo " PYCODESTYLE_CONFIG = $(PYCODESTYLE_CONFIG)"


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
