# ----------------------------------------------------------------------------
# Makefile part of make4py
#
# Copyright (c) 2023 by Clemens Rabe <clemens.rabe@clemensrabe.de>
# All rights reserved.
# This file is part of make4py (https://github.com/seeraven/make4py)
# and is released under the "BSD 3-Clause License". Please see the LICENSE file
# that is included as part of this package.
# ----------------------------------------------------------------------------


ifneq ($(UNITTEST_DIR),)

.PHONY: unittests unittests-coverage


ifeq ($(SWITCH_TO_VENV),1)

unittests: unittests.venv
unittests-coverage: unittests-coverage.venv

else

unittests:
	@pytest $(UNITTEST_DIR)

unittests-coverage:
	@$(call RMFILE,.coverage.unittests)
	@$(call RMDIR,doc/unittests-coverage)
	@COVERAGE_FILE=.coverage.unittests \
	pytest --cov --cov-report=term --cov-report=html:doc/unittests-coverage $(UNITTEST_DIR)

endif


endif


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
