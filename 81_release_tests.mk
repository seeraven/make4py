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
#  SETTINGS
# ----------------------------------------------------------------------------
UBUNTU_RELEASE_TEST_TARGETS := $(foreach ver,$(UBUNTU_DIST_VERSIONS),$(RELEASE_DIR)/$(APP_NAME)_v$(APP_VERSION)_Ubuntu$(ver)_x86_64.release_test.venv.ubuntu$(ver))
WINDOWS_RELEASE_TEST_TARGETS := $(WINDOWS_RELEASE_FILES).release_test.venv.windows


# ----------------------------------------------------------------------------
#  TARGETS
# ----------------------------------------------------------------------------

ifneq ($(FUNCTEST_DIR),)

.PHONY: test-current-release test-releases

ifeq ($(ON_WINDOWS),0)

ifeq ($(ENABLE_WINDOWS_SUPPORT),1)
test-releases: $(UBUNTU_RELEASE_TEST_TARGETS) $(WINDOWS_RELEASE_TEST_TARGETS)
else
test-releases: $(UBUNTU_RELEASE_TEST_TARGETS)
endif

else

test-releases: $(WINDOWS_RELEASE_FILES).release_test.venv

endif

test-current-release: $(CURRENT_RELEASE_FILE).release_test.venv

%.release_test: %
	@echo "Testing release $*..."
ifneq (,$(findstring --onefile,$(PYINSTALLER_ARGS)))
	@pytest $(FUNCTEST_SELECTION) --executable $* $(FUNCTEST_DIR)
else
  ifeq ($(ON_WINDOWS),1)
	pytest $(FUNCTEST_SELECTION) --executable $*/$(APP_NAME).exe $(FUNCTEST_DIR)
  else
	pytest $(FUNCTEST_SELECTION) --executable $*/$(APP_NAME) $(FUNCTEST_DIR)
  endif
endif
	@echo "Release $* tested successfully."

endif


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
