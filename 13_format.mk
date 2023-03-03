# ----------------------------------------------------------------------------
# Makefile part of make4py
#
# Copyright (c) 2023 by Clemens Rabe <clemens.rabe@clemensrabe.de>
# All rights reserved.
# This file is part of make4py (https://github.com/seeraven/make4py)
# and is released under the "BSD 3-Clause License". Please see the LICENSE file
# that is included as part of this package.
# ----------------------------------------------------------------------------


.PHONY: format black isort \
	format-check black-check isort-check \
	format-diff black-diff isort-diff

format: black isort

format-check: black-check isort-check

format-diff: black-diff isort-diff


black:
	@black $(SRC_DIRS)

black-check:
	@black --check $(SRC_DIRS)

black-diff:
	@black --diff $(SRC_DIRS)


isort:
	@isort $(SRC_DIRS)

isort-check:
	@isort --check $(SRC_DIRS)

isort-diff:
	@isort --diff $(SRC_DIRS)


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
