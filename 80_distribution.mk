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
UBUNTU_RELEASE_FILES    := $(foreach ver,$(UBUNTU_DIST_VERSIONS),$(RELEASE_DIR)/$(APP_NAME)_v$(APP_VERSION)_Ubuntu$(ver)_x86_64)
ALPINE_RELEASE_FILES    := $(foreach ver,$(ALPINE_DIST_VERSIONS),$(RELEASE_DIR)/$(APP_NAME)_v$(APP_VERSION)_Alpine$(ver)_x86_64)
ifeq ($(PYINSTALLER_ONEFILE),1)
  WINDOWS_RELEASE_FILES   := $(RELEASE_DIR)/$(APP_NAME)_v$(APP_VERSION)_win10_64bit.exe
else
  WINDOWS_RELEASE_FILES   := $(RELEASE_DIR)/$(APP_NAME)_v$(APP_VERSION)_win10_64bit
endif

ifeq ($(USE_VENV),1)
  UBUNTU_RELEASE_TARGETS  := $(foreach ver,$(UBUNTU_DIST_VERSIONS),$(RELEASE_DIR)/$(APP_NAME)_v$(APP_VERSION)_Ubuntu$(ver)_x86_64.venv.ubuntu$(ver))
  ALPINE_RELEASE_TARGETS  := $(foreach ver,$(ALPINE_DIST_VERSIONS),$(RELEASE_DIR)/$(APP_NAME)_v$(APP_VERSION)_Alpine$(ver)_x86_64.venv.alpine$(ver))
  WINDOWS_RELEASE_TARGETS := $(WINDOWS_RELEASE_FILES).venv.windows
else
  UBUNTU_RELEASE_TARGETS  := $(foreach ver,$(UBUNTU_DIST_VERSIONS),$(RELEASE_DIR)/$(APP_NAME)_v$(APP_VERSION)_Ubuntu$(ver)_x86_64.ubuntu$(ver))
  ALPINE_RELEASE_TARGETS  := $(foreach ver,$(ALPINE_DIST_VERSIONS),$(RELEASE_DIR)/$(APP_NAME)_v$(APP_VERSION)_Alpine$(ver)_x86_64.alpine$(ver))
  WINDOWS_RELEASE_TARGETS := $(WINDOWS_RELEASE_FILES).windows
endif

ifeq ($(ON_WINDOWS),1)
  ifeq ($(PYINSTALLER_ONEFILE),1)
    DIST_FILE            := dist/$(APP_NAME).exe
  else
    DIST_FILE            := dist/$(APP_NAME)
  endif
  CURRENT_RELEASE_FILE := $(WINDOWS_RELEASE_FILES)
  PYINSTALLER_WORK_DIR := $(BUILD_DIR)\pyinstaller_$(WIN_PLATFORM_STRING)$(PLATFORM_SUFFIX)
else
  DIST_FILE            := dist/$(APP_NAME)
  CURRENT_RELEASE_FILE := $(RELEASE_DIR)/$(APP_NAME)_v$(APP_VERSION)_$(LINUX_PLATFORM_STRING)
  PYINSTALLER_WORK_DIR := $(BUILD_DIR)/pyinstaller_$(LINUX_PLATFORM_STRING)$(PLATFORM_SUFFIX)
endif


# ----------------------------------------------------------------------------
#  TARGETS
# ----------------------------------------------------------------------------
.PHONY: current-release releases

ifeq ($(ON_WINDOWS),0)

ifeq ($(ENABLE_WINDOWS_SUPPORT),1)
releases: $(UBUNTU_RELEASE_TARGETS) $(ALPINE_RELEASE_TARGETS) $(WINDOWS_RELEASE_TARGETS)
else
releases: $(UBUNTU_RELEASE_TARGETS) $(ALPINE_RELEASE_TARGETS)
endif

else

ifeq ($(USE_VENV),1)
releases: $(WINDOWS_RELEASE_FILES).venv
else
releases: $(WINDOWS_RELEASE_FILES)
endif

endif

current-release: $(CURRENT_RELEASE_FILE)

ifeq ($(SWITCH_TO_VENV),1)

$(CURRENT_RELEASE_FILE):
	@make $@.venv

else

$(CURRENT_RELEASE_FILE): $(SOURCES)
ifeq ($(PYINSTALLER_ONEFILE),1)
	@$(call RMFILE,$(DIST_FILE))
else
	@$(call RMDIRR,$(DIST_FILE))
endif
ifeq ($(PYINSTALLER_SPEC),)
	@pyinstaller $(PYINSTALLER_ARGS) --workpath $(PYINSTALLER_WORK_DIR) --name $(APP_NAME) $(SCRIPT)
else
	@pyinstaller $(PYINSTALLER_ARGS) --workpath $(PYINSTALLER_WORK_DIR) $(PYINSTALLER_SPEC)
endif
	@$(call MKDIR,releases)
	@$(call MOVE,$(DIST_FILE) $(CURRENT_RELEASE_FILE))
ifeq ($(PYINSTALLER_ONEFILE),0)
	@$(call ZIP,releases,$(notdir $(CURRENT_RELEASE_FILE)),$(notdir $(CURRENT_RELEASE_FILE)))
endif

endif

ifeq ($(ON_WINDOWS),0)
$(filter-out $(CURRENT_RELEASE_FILE),$(UBUNTU_RELEASE_FILES)): $(RELEASE_DIR)/$(APP_NAME)_v$(APP_VERSION)_Ubuntu%_x86_64:
	@make $@.venv.ubuntu$*

$(filter-out $(CURRENT_RELEASE_FILE),$(ALPINE_RELEASE_FILES)): $(RELEASE_DIR)/$(APP_NAME)_v$(APP_VERSION)_Alpine%_x86_64:
	@make $@.venv.alpine$*

ifeq ($(ENABLE_WINDOWS_SUPPORT),1)
$(WINDOWS_RELEASE_FILES):
	@make $@.venv.windows
endif
endif


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
