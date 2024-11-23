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
#  FIRST INCLUDE BLOCK
# ----------------------------------------------------------------------------
MAKE4PY_DIR            := $(dir $(lastword $(MAKEFILE_LIST)))
MAKE4PY_DIR_ABS        := $(abspath $(MAKE4PY_DIR))
USE_VENV               := $(or $(USE_VENV),1)

include $(MAKE4PY_DIR)01_check_settings.mk
include $(MAKE4PY_DIR)02_platform_support.mk


# ----------------------------------------------------------------------------
#  DEFAULT SETTINGS
# ----------------------------------------------------------------------------
ALL_TARGET               := $(or $(ALL_TARGET),help)
BUILD_DIR                := $(or $(BUILD_DIR),build)
UBUNTU_DIST_VERSIONS     := $(or $(UBUNTU_DIST_VERSIONS),18.04 20.04 22.04)
ALPINE_PYTHON_VERSION    := $(or $(ALPINE_PYTHON_VERSION),3.12)
ALPINE_DIST_VERSIONS     := $(or $(ALPINE_DIST_VERSIONS),)
ENABLE_WINDOWS_SUPPORT   := $(or $(ENABLE_WINDOWS_SUPPORT),1)
PYCODESTYLE_CONFIG       := $(or $(PYCODESTYLE_CONFIG),$(MAKE4PY_DIR)/.pycodestyle)
SRC_DIRS                 := $(or $(SRC_DIRS),$(wildcard src/. test/.))
SOURCES                  := $(or $(SOURCES),$(SCRIPT) $(call rwildcard,$(SRC_DIRS),*.py))
DOC_SUPPORT              := $(wildcard doc/*/conf.py)
DOC_MODULES              := $(or $(DOC_MODULES),$(dir $(wildcard src/*/__init__.py)))
UNITTEST_DIR             := $(or $(UNITTEST_DIR),$(wildcard test/unittests/.))
FUNCTEST_DIR             := $(or $(FUNCTEST_DIR),$(wildcard test/functional_tests/.))
TEST_SUPPORT             := $(or $(UNITTEST_DIR),$(FUNCTEST_DIR))
RELEASE_DIR              := $(or $(RELEASE_DIR),releases)
PYINSTALLER_ARGS_VAR     := PYINSTALLER_ARGS_$(SHORT_PLATFORM)
PYINSTALLER_ARGS         := $(or $($(PYINSTALLER_ARGS_VAR)),$(or $(PYINSTALLER_ARGS),--clean --onefile))
PYINSTALLER_ARGS_WINDOWS := $(or $(PYINSTALLER_ARGS_WINDOWS),$(PYINSTALLER_ARGS))
PYINSTALLER_ARGS_LINUX   := $(or $(PYINSTALLER_ARGS_LINUX),$(PYINSTALLER_ARGS))
PYINSTALLER_ARGS_DARWIN  := $(or $(PYINSTALLER_ARGS_DARWIN),$(PYINSTALLER_ARGS))
CLEAN_FILES              := $(or $(CLEAN_FILES),)
CLEAN_DIRS               := $(or $(CLEAN_DIRS),)
CLEAN_DIRS_RECURSIVE     := $(or $(CLEAN_DIRS_RECURSIVE),)
VARS_TO_PROPAGATE        := $(or $(VARS_TO_PROPAGATE),UNITTESTS FUNCTESTS)


# ----------------------------------------------------------------------------
#  DEFAULT TARGET (FIRST TARGET)
# ----------------------------------------------------------------------------
.PHONY: all

all: $(ALL_TARGET)


# ----------------------------------------------------------------------------
#  SECOND INCLUDE BLOCK
# ----------------------------------------------------------------------------
include $(MAKE4PY_DIR)03_ensure_python_version.mk
include $(MAKE4PY_DIR)04_validate_pyproject.mk
include $(MAKE4PY_DIR)10_pip_dependency_pinning.mk
include $(MAKE4PY_DIR)20_system_setup.mk
include $(MAKE4PY_DIR)21_venv_support.mk
include $(MAKE4PY_DIR)30_multi_platform_docker.mk
include $(MAKE4PY_DIR)31_multi_platform_vagrant.mk
include $(MAKE4PY_DIR)32_multi_platform_all.mk
include $(MAKE4PY_DIR)40_check_style.mk
include $(MAKE4PY_DIR)50_unittests.mk
include $(MAKE4PY_DIR)51_functional_tests.mk
include $(MAKE4PY_DIR)60_documentation.mk
include $(MAKE4PY_DIR)70_format.mk
include $(MAKE4PY_DIR)80_distribution.mk
include $(MAKE4PY_DIR)81_release_tests.mk


# ----------------------------------------------------------------------------
#  USAGE
# ----------------------------------------------------------------------------
.PHONY: help help-all show-env

help:
	@echo "Makefile for $(APP_NAME) ($(APP_VERSION)):"
	@echo ""
	@echo "Target suffixes:"
ifeq ($(ON_WINDOWS),0)
	@echo " .ubuntuXX.YY              : Execute the make target in a docker"
	@echo "                             container running Ubuntu XX.YY. The"
	@echo "                             supported Ubuntu versions are $(UBUNTU_DIST_VERSIONS)"
	@echo " .ubuntu                   : Execute the make target on all"
	@echo "                             supported Ubuntu versions $(UBUNTU_DIST_VERSIONS)."
	@echo " .alpineXX.YY              : Execute the make target in a docker"
	@echo "                             container running Alpine Linux XX.YY. The"
	@echo "                             supported Alpine versions are $(ALPINE_DIST_VERSIONS)"
	@echo " .alpine                   : Execute the make target on all"
	@echo "                             supported Alpine versions $(ALPINE_DIST_VERSIONS)."
ifeq ($(ENABLE_WINDOWS_SUPPORT),1)
	@echo " .windows                  : Execute the make target in a vagrant"
	@echo "                             box running Windows."
endif
	@echo " .all                      : Execute the make target on all platforms."
endif
	@echo " .venv                     : Execute the make target in a virtual environment (venv)."
ifeq ($(USE_VENV),1)
	@echo "                             Note: Usually you do not need to specify this as this"
	@echo "                             project is already configured to use a venv automatically!"
endif
	@echo ""
	@echo " Multiple suffixes can be used that are processed from right to left, e.g.,"
	@echo " the target pip-deps-upgrade.venv.ubuntu22.04 runs pip-deps-upgrade.venv in"
	@echo " an Ubuntu 22.04 docker which in turn runs the target pip-deps-upgrade in"
	@echo " a venv."
	@echo ""
ifeq ($(USE_VENV),0)
	@echo "WARNING:"
	@echo " This project is configured to NOT use virtual environments, which means"
	@echo " that all targets are executed within the host environment unless you use"
	@echo " the '.venv' suffix!"
	@echo ""
endif
	@echo "Note: In the following, the high-level targets are specified with the"
	@echo "      recommended environment. Call 'make help-all' to see all available"
	@echo "      targets."
	@echo ""
	@echo "Common Targets:"
	@echo " help-all                  : Describe all targets."
	@echo " pip-deps-upgrade-all      : Update the pip-dependencies in all"
	@echo "                             supported environments."
	@echo " format                    : Call black and isort on the source files."
	@echo " check-style               : Call pylint, pycodestyle, flake8 and mypy."
ifneq ($(UNITTEST_DIR),)
  ifneq ($(FUNCTEST_DIR),)
	@echo " tests                     : Execute the unittests and functional tests."
	@echo " tests-coverage            : Execute the unittests and functional tests"
	@echo "                             and collect the code coverage."
  else
	@echo " unittests                 : Execute the unittests. Use the UNITTESTS variable to"
	@echo "                             execute only the selected ones."
	@echo " unittests-list            : List all available unittests."
	@echo " unittests-coverage        : Execute the unittests and collect the code coverage."
	@echo "                             Use the UNITTESTS variable to execute only the selected ones."
  endif
else
  ifneq ($(FUNCTEST_DIR),)
	@echo " functional-tests               : Execute the functional tests. Use the FUNCTESTS variable to"
	@echo "                                  execute only the selected ones."
	@echo " functional-tests-list          : List all available functional tests."
	@echo " functional-tests-coverage      : Execute the functional tests and collect the code coverage."
	@echo "                                  Use the FUNCTESTS variable to execute only the selected ones."
  endif
endif
ifneq ($(DOC_SUPPORT),)
	@echo " doc                       : Generate the documentation."
	@echo " man                       : Generate the man page."
endif
	@echo " current-release           : Build the release for this platform."
	@echo " releases                  : Build the releases for all platforms."
	@echo " clean                     : Remove all temporary files."
	@echo " distclean                 : Like above but also remove releases and all venvs."
ifeq ($(ON_WINDOWS),0)
	@echo " clean-dockerimages        : Remove all generated docker images."
endif
	@echo ""


help-all:
	@echo "Makefile for $(APP_NAME) ($(APP_VERSION)):"
	@echo ""
	@echo "Target suffixes:"
ifeq ($(ON_WINDOWS),0)
	@echo " .ubuntuXX.YY              : Execute the make target in a docker"
	@echo "                             container running Ubuntu XX.YY. The"
	@echo "                             supported Ubuntu versions are $(UBUNTU_DIST_VERSIONS)"
	@echo " .ubuntu                   : Execute the make target on all"
	@echo "                             supported Ubuntu versions $(UBUNTU_DIST_VERSIONS)."
	@echo " .alpineXX.YY              : Execute the make target in a docker"
	@echo "                             container running Alpine Linux XX.YY. The"
	@echo "                             supported Alpine versions are $(ALPINE_DIST_VERSIONS)"
	@echo " .alpine                   : Execute the make target on all"
	@echo "                             supported Alpine versions $(ALPINE_DIST_VERSIONS)."
ifeq ($(ENABLE_WINDOWS_SUPPORT),1)
	@echo " .windows                  : Execute the make target in a vagrant"
	@echo "                             box running Windows."
endif
	@echo " .all                      : Execute the make target on all platforms."
endif
	@echo " .venv                     : Execute the make target in a virtual environment (venv)."
ifeq ($(USE_VENV),1)
	@echo "                             Note: Usually you do not need to specify this as this"
	@echo "                             project is already configured to use a venv automatically!"
endif
	@echo ""
	@echo " Multiple suffixes can be used that are processed from right to left, e.g.,"
	@echo " the target pip-deps-upgrade.venv.ubuntu22.04 runs pip-deps-upgrade.venv in"
	@echo " an Ubuntu 22.04 docker which in turn runs the target pip-deps-upgrade in"
	@echo " a venv."
	@echo ""
ifeq ($(USE_VENV),0)
	@echo "WARNING:"
	@echo " This project is configured to NOT use virtual environments, which means"
	@echo " that all targets are executed within the host environment unless you use"
	@echo " the '.venv' suffix!"
	@echo ""
endif
	@echo "Targets for Validation:"
	@echo " validate-pyproject-toml   : Validate the pyproject.toml file."
	@echo ""
	@echo "Targets for PIP Dependency Pinning:"
	@echo " pip-deps-upgrade          : Update the pip-dependencies extracted"
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
	@echo " venv-bash                 : Open a shell (in the venv)."
	@echo " ipython                   : Open ipython (in the venv)."
	@echo ""
ifeq ($(ON_WINDOWS),0)
ifeq ($(ENABLE_WINDOWS_SUPPORT),1)
	@echo "Targets for Windows Vagrant Box:"
	@echo " destroy-windows           : Destroy the vagrant box."
	@echo " update-windows-box        : Update the vagrant box."
	@echo " start-windows-box         : Start the vagrant box."
	@echo " ssh-windows-box           : Enter a running vagrant box via ssh."
	@echo ""
endif
endif
	@echo "Targets for Style Checking:"
	@echo " check-style               : Call pylint, pycodestyle, flake8 and mypy."
	@echo " pylint                    : Call pylint on the source files."
	@echo " pycodestyle               : Call pycodestyle on the source files."
	@echo " flake8                    : Call flake8 on the source files."
	@echo " mypy                      : Call mypy on the source files."
	@echo ""
	@echo "Targets for Formatting:"
	@echo " format                    : Call black and isort on the source files."
	@echo " format-check              : Call black and isort to check the formatting"
	@echo "                             of the source files."
	@echo " format-diff               : Call black and isort to check the formatting"
	@echo "                             of the source files and print the differences."
	@echo " black                     : Call black on the source files."
	@echo " black-check               : Call black to check the formatting of the source files."
	@echo " black-diff                : Call black to check the formatting of the source files"
	@echo "                             and print the differences."
	@echo " isort                     : Call isort on the source files."
	@echo " isort-check               : Call isort to check the formatting of the source files."
	@echo " isort-diff                : Call isort to check the formatting of the source files"
	@echo "                             and print the differences."
	@echo ""
ifneq ($(TEST_SUPPORT),)
	@echo "Targets for Testing:"
ifneq ($(UNITTEST_DIR),)
ifneq ($(FUNCTEST_DIR),)
	@echo " tests                     : Execute the unittests and the functional-tests."
	@echo " tests-coverage            : Execute the unittests and the functional-tests and collect"
	@echo "                             the code coverage."
endif
	@echo " unittests                 : Execute the unittests. Use the UNITTESTS variable to"
	@echo "                             execute only the selected ones."
	@echo " unittests-list            : List all available unittests."
	@echo " unittests-coverage        : Execute the unittests and collect the code coverage."
	@echo "                             Use the UNITTESTS variable to execute only the selected ones."
endif
ifneq ($(FUNCTEST_DIR),)
	@echo " functional-tests               : Execute the functional tests. Use the FUNCTESTS variable to"
	@echo "                                  execute only the selected ones."
	@echo " functional-tests-list          : List all available functional tests."
	@echo " functional-tests-coverage      : Execute the functional tests and collect the code coverage."
	@echo "                                  Use the FUNCTESTS variable to execute only the selected ones."
endif
	@echo ""
endif
ifneq ($(DOC_SUPPORT),)
	@echo "Targets for Documentation Generation:"
	@echo " apidoc                    : Generate the API documentation."
	@echo " doc                       : Generate the documentation."
	@echo " man                       : Generate the man page."
	@echo ""
endif
	@echo "Targets for Distribution:"
	@echo " current-release           : Build the release for this platform."
	@echo " releases                  : Build the releases for all platforms."
ifneq ($(FUNCTEST_DIR),)
	@echo " test-current-release      : Test the release for this platform with the functional test suite."
	@echo " test-releases             : Test the releases with the functional test suite."
endif
	@echo ""
	@echo "Targets for Cleanup:"
	@echo " clean                     : Remove all temporary files."
	@echo " distclean                 : Like above but also remove releases and all venvs."
ifeq ($(ON_WINDOWS),0)
	@echo " clean-dockerimages        : Remove all generated docker images."
endif
	@echo ""
	@echo "Development Information:"
	@echo " PWD                = $(PWD)"
	@echo " CURDIR             = $(CURDIR)"
	@echo " MAKE4PY_DIR        = $(MAKE4PY_DIR)"
	@echo " MAKE4PY_DIR_ABS    = $(MAKE4PY_DIR_ABS)"


show-env:
	@echo "Environment:"
	@echo " PWD                = $(PWD)"
	@echo " CURDIR             = $(CURDIR)"
	@echo " MAKE4PY_DIR        = $(MAKE4PY_DIR)"
	@echo " MAKE4PY_DIR_ABS    = $(MAKE4PY_DIR_ABS)"
	@echo " SHORT_PLATFORM     = $(SHORT_PLATFORM)"
	@echo " ON_WINDOWS         = $(ON_WINDOWS)"
	@echo " IN_VENV            = $(IN_VENV)"
	@echo " VENV_DIR           = $(VENV_DIR)"
	@echo " VENV_ACTIVATE      = $(VENV_ACTIVATE)"
	@echo " VENV_SHELL         = $(VENV_SHELL)"
	@echo " INTERACTIVE_SHELL  = $(INTERACTIVE_SHELL)"
	@echo " SWITCH_TO_VENV     = $(SWITCH_TO_VENV)"
	@echo " SHELL              = $(SHELL)"
	@echo " PYTHON             = $(PYTHON)"
	@echo " SET_PYTHONPATH     = $(SET_PYTHONPATH)"
	@echo " IN_DOCKER          = $(IN_DOCKER)"
	@echo " PYINSTALLER_ARGS   = $(PYINSTALLER_ARGS)"
	@echo " LINUX_PLATFORM_STRING = $(LINUX_PLATFORM_STRING)"


# ----------------------------------------------------------------------------
#  MAINTENANCE TARGETS
# ----------------------------------------------------------------------------

distclean: clean
	@$(call RMDIRR,build)
	@$(call RMDIRR,releases)
	@$(call RMDIRR,.mypy_cache)

clean:
	@$(call RMDIR,$(VENV_DIR) .pytest_cache dist build doc/build doc/*coverage doc/source/apidoc $(CLEAN_DIRS))
	@$(call RMFILE,.coverage* .coverage-* *.spec $(CLEAN_FILES))
	@$(call RMDIRR,__pycache__)
	@$(call RMDIRR,*.egg-info)
	@$(foreach d,$(CLEAN_DIRS_RECURSIVE),$(call RMDIRR,$d))
	@$(call RMFILER,*~)
	@$(call RMFILER,*.pyc)


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
