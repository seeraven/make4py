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
#  VENV Detection
# ----------------------------------------------------------------------------
ifdef VIRTUAL_ENV
    IN_VENV        := 1
    SWITCH_TO_VENV := 0
else
    IN_VENV        := 0
    SWITCH_TO_VENV := $(USE_VENV)
endif


# ----------------------------------------------------------------------------
#  FUNCTIONS
# ----------------------------------------------------------------------------

# Recursive wildcard function. Call with: $(call rwildcard,<start dir>,<pattern>)
rwildcard = $(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))


# ----------------------------------------------------------------------------
#  SETTINGS
# ----------------------------------------------------------------------------

ifeq ($(ON_WINDOWS),1)
    PWD    := $(CURDIR)
    PYTHON := python
    SHELL  := cmd
    WIN_PLATFORM_STRING := $(shell python -c "import platform;print(f'win{platform.release()}_{platform.architecture()[0]}',end='')")
    SHORT_PLATFORM := WINDOWS
    SET_PYTHONPATH := set PYTHONPATH=$(PYTHONPATH) &
    FIX_PATH = $(subst /,\\,$1)
    RMDIR    = rmdir /S /Q $(call FIX_PATH,$1) 2>nul || ver >nul
    RMDIRR   = for /d /r %%i in (*$1*) do @rmdir /s /q "%%i"
    RMFILE   = del /Q $(call FIX_PATH,$1) 2>nul || ver >nul
    RMFILER  = del /Q /S $(call FIX_PATH,$1) 2>nul || ver >nul
    MKDIR    = mkdir $(call FIX_PATH,$1) || ver >nul
    COPY     = copy $(call FIX_PATH,$1) $(call FIX_PATH,$2)
    MOVE     = move $(call FIX_PATH,$1) $(call FIX_PATH,$2)
    # $(call ZIP,<BASEDIR>,<SUBDIR>,<OUTFILE W/O SUFFIX>)
    ZIP      = cd $(call FIX_PATH,$1) & tar -a -c -f $(call FIX_PATH,$3).zip $(call FIX_PATH,$2)
else
    SHELL  = /bin/bash
    PYTHON := python3
    ifeq (, $(shell which lsb_release))
        LINUX_PLATFORM_STRING := $(shell uname -s)_$(shell uname -m)
    else
        LINUX_PLATFORM_STRING := $(shell lsb_release -i -s)$(shell lsb_release -r -s | grep -o -E "[0-9]+.[0-9]+")_$(shell uname -m)
    endif
    SHORT_PLATFORM := $(shell uname -s | tr '[:lower:]' '[:upper:]')
    SET_PYTHONPATH := PYTHONPATH=$(PYTHONPATH)
    RMDIR    = rm -rf $1
    RMDIRR   = find . -name "$1" -exec rm -rf {} \; 2>/dev/null || true
    RMFILE   = rm -f $1
    RMFILER  = find . -iname "$1" -exec rm -f {} \;
    MKDIR    = mkdir -p $1
    COPY     = cp -a $1 $2
    MOVE     = mv $1 $2
    ZIP      = cd $1 && tar cfz $3.tgz $2
endif

ifeq ($(IN_DOCKER),1)
    PLATFORM_SUFFIX := _docker
else
    PLATFORM_SUFFIX :=
endif


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
