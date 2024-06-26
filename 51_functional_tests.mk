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

.PHONY: functional-tests functional-tests-list functional-tests-coverage

ifneq ($(strip $(FUNCTESTS)),)
FUNCTEST_SELECTION := -k "$(FUNCTESTS)"
endif

ifeq ($(SWITCH_TO_VENV),1)

functional-tests: functional-tests.venv
functional-tests-list: functional-tests-list.venv
functional-tests-coverage: functional-tests-coverage.venv

else

ifeq ($(ON_WINDOWS),1)

functional-tests: $(SOURCES)
	@pytest $(FUNCTEST_SELECTION) --executable "python $(SCRIPT)" $(FUNCTEST_DIR)

else

functional-tests: $(SOURCES)
	@pytest $(FUNCTEST_SELECTION) $(FUNCTEST_DIR)

endif

functional-tests-list: $(SOURCES)
	@pytest --collect-only $(FUNCTEST_DIR)

functional-tests-coverage: $(SOURCES)
	@$(call RMFILE,.coverage.functests)
	@$(call RMDIR,doc/functional-tests-coverage)
	@COVERAGE_FILE=.coverage.functests \
	pytest --cov --cov-report=term --cov-report=html:doc/functional-tests-coverage $(FUNCTEST_SELECTION) $(FUNCTEST_DIR)

endif

endif


ifneq ($(FUNCTEST_DIR),)
ifneq ($(UNITTEST_DIR),)
.PHONY: tests tests-coverage

tests: unittests functional-tests

ifeq ($(SWITCH_TO_VENV),1)

tests-coverage: tests-coverage.venv

else

tests-coverage: unittests-coverage functional-tests-coverage
	@coverage combine
	@coverage report
	@$(call RMDIR,doc/tests-coverage)
	@coverage html -d doc/tests-coverage

endif

endif
endif


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
