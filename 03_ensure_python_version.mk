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
#  Ensure Python 3.8+
# ----------------------------------------------------------------------------
PYTHON_MINOR := $(shell $(PYTHON) -c "import sys;print(sys.version_info[1],end='')")

ifeq ($(PYTHON_MINOR),6)
  ifeq ($(ON_WINDOWS),0)
    ifneq (,$(shell which python3.8))
      PYTHON := python3.8
      PYTHON_MINOR := $(shell $(PYTHON) -c "import sys;print(sys.version_info[1],end='')")
    endif
  endif
endif

ifeq ($(PYTHON_MINOR),6)
  $(warning Old python 3.6 detected. Please install at least python 3.8!)
  ifeq ($(ON_WINDOWS),0)
    $(info On Ubuntu 18.04, you can install python 3.8 in parallel by calling the following commands:)
    $(info $A  sudo apt-get install python3.8-dev python3.8-venv)
  endif
  $(error Python version not supported)
endif


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
