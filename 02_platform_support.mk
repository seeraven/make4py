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
#  OS Detection
# ----------------------------------------------------------------------------
ifdef OS
    ON_WINDOWS = 1
else
    ON_WINDOWS = 0
endif


# ----------------------------------------------------------------------------
#  SETTINGS
# ----------------------------------------------------------------------------

ifeq ($(ON_WINDOWS),1)
    PWD    := $(CURDIR)
    PYTHON := python
    WIN_PLATFORM_STRING := $(shell python -c "import platform;print(f'win{platform.release()}_{platform.architecture()[0]}',end='')")
    SET_PYTHONPATH := set PYTHONPATH=$(PYTHONPATH) &
    FIX_PATH = $(subst /,\\,$1)
    RMDIR    = rmdir /S /Q $(call FIX_PATH,$1) 2>nul || ver >nul
    RMDIRR   = for /d /r %%i in (*$1*) do @rmdir /s /q "%%i"
    RMFILE   = del /Q $(call FIX_PATH,$1) 2>nul || ver >nul
    RMFILER  = del /Q /S $(call FIX_PATH,$1) 2>nul || ver >nul
    MKDIR    = mkdir $(call FIX_PATH,$1) || ver >nul
    COPY     = copy $(call FIX_PATH,$1) $(call FIX_PATH,$2)
else
    SHELL   = /bin/bash
    PYTHON := python3
    SET_PYTHONPATH := PYTHONPATH=$(PYTHONPATH)
    RMDIR    = rm -rf $1
    RMDIRR   = find . -name "$1" -exec rm -rf {} \; 2>/dev/null || true
    RMFILE   = rm -f $1
    RMFILER  = find . -iname "$1" -exec rm -f {} \;
    MKDIR    = mkdir -p $1
    COPY     = cp -a $1 $2
endif


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
