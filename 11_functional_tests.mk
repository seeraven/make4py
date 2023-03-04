# ----------------------------------------------------------------------------
# Makefile part of make4py
#
# Copyright (c) 2023 by Clemens Rabe <clemens.rabe@clemensrabe.de>
# All rights reserved.
# This file is part of make4py (https://github.com/seeraven/make4py)
# and is released under the "BSD 3-Clause License". Please see the LICENSE file
# that is included as part of this package.
# ----------------------------------------------------------------------------


ifneq ($(FUNCTEST_DIR),)

.PHONY: functional-tests functional-tests-coverage

functional-tests:
	@pytest $(FUNCTEST_DIR)

functional-tests-coverage:
	@$(call RMFILE,.coverage.functests)
	@$(call RMDIR,doc/functional-tests-coverage)
	@COVERAGE_FILE=.coverage.functests \
	pytest --cov --cov-report=term --cov-report=html:doc/functional-tests-coverage $(FUNCTEST_DIR)

endif


ifneq ($(FUNCTEST_DIR),)
ifneq ($(UNITTEST_DIR),)
.PHONY: tests tests-coverage

tests: unittests functional-tests

tests-coverage: unittests-coverage functional-tests-coverage
	@coverage combine
	@coverage report
	@$(call RMDIR,doc/tests-coverage)
	@coverage html -d doc/tests-coverage

endif
endif


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
