# ----------------------------------------------------------------------------
# Makefile for <your project>
#
# Copyright (c) 2023 by <author>
# All rights reserved.
# This file is part of <your project> (<url>)
# and is released under the "BSD 3-Clause License". Please see the LICENSE file
# that is included as part of this package.
# ----------------------------------------------------------------------------


# ----------------------------------------------------------------------------
#  SETTINGS
# ----------------------------------------------------------------------------
APP_NAME             := make4py-example
APP_VERSION          := 0.0.1

ALL_TARGET           := check-style.venv
SCRIPT               := src/example_app.py


# ----------------------------------------------------------------------------
#  MAKE4PY INTEGRATION
# ----------------------------------------------------------------------------
include .make4py/make4py.mk


# ----------------------------------------------------------------------------
#  OWN TARGETS
# ----------------------------------------------------------------------------
.PHONY: precheck-releases

precheck-releases: check-style.all tests.all doc man


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
