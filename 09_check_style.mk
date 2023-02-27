# ----------------------------------------------------------------------------
# Makefile part of make4py
#
# Copyright (c) 2023 by Clemens Rabe <clemens.rabe@clemensrabe.de>
# All rights reserved.
# This file is part of make4py (https://github.com/seeraven/make4py)
# and is released under the "BSD 3-Clause License". Please see the LICENSE file
# that is included as part of this package.
# ----------------------------------------------------------------------------


.PHONY: check-style pylint pycodestyle flake8 mypy

check-style: pylint pycodestyle flake8 mypy

pylint:
	@pylint --recursive=true $(SRC_DIRS)
	@echo "pylint found no errors."

pycodestyle:
	@pycodestyle --config=$(PYCODESTYLE_CONFIG) $(SRC_DIRS)
	@echo "pycodestyle found no errors."

flake8:
	@flake8 $(SRC_DIRS)
	@echo "flake8 found no errors."

mypy:
	@mypy $(SRC_DIRS)
	@echo "mypy found no errors."


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
