# ----------------------------------------------------------------------------
# Makefile part of make4py
#
# Copyright (c) 2023 by Clemens Rabe <clemens.rabe@clemensrabe.de>
# All rights reserved.
# This file is part of make4py (https://github.com/seeraven/make4py)
# and is released under the "BSD 3-Clause License". Please see the LICENSE file
# that is included as part of this package.
# ----------------------------------------------------------------------------


ifeq ($(ON_WINDOWS),0)
UBUNTU_DOCKER_IMAGES         := $(addprefix dockerimage_ubuntu,$(UBUNTU_DIST_VERSIONS))
ALPINE_DOCKER_IMAGES         := $(addprefix dockerimage_alpine,$(ALPINE_DIST_VERSIONS))
DOCKER_STAMPS_DIR            := $(or $(DOCKER_STAMPS_DIR),$(CURDIR)/.dockerstamps)
MAKE4PY_DOCKER_IMAGE         := $(or $(MAKE4PY_DOCKER_IMAGE),make4py)
MAKE4PY_DOCKER_PKGS          := $(or $(MAKE4PY_DOCKER_PKGS),)
MAKE4PY_ALPINE_DOCKER_PKGS   := $(or $(MAKE4PY_ALPINE_DOCKER_PKGS),)
MAKE4PY_DOCKER_SETUP_SCRIPTS := $(or $(MAKE4PY_DOCKER_SETUP_SCRIPTS),)
MAKE4PY_UBUNTU_DOCKER_IMAGES := $(addprefix $(MAKE4PY_DOCKER_IMAGE):ubuntu,$(UBUNTU_DIST_VERSIONS))
MAKE4PY_ALPINE_DOCKER_IMAGES := $(addprefix $(MAKE4PY_DOCKER_IMAGE):alpine,$(ALPINE_DIST_VERSIONS))
PROPAGATE_ARGS               := $(foreach VAR_NAME,$(VARS_TO_PROPAGATE),-e $(VAR_NAME)="$($(VAR_NAME))" )

.PHONY: $(UBUNTU_DOCKER_IMAGES) $(ALPINE_DOCKER_IMAGES) clean-dockerimages

$(DOCKER_STAMPS_DIR)/$(MAKE4PY_DOCKER_IMAGE)\:ubuntu%: $(MAKE4PY_DIR_ABS)/.dockerfiles/Dockerfile.ubuntu $(MAKE4PY_DOCKER_SETUP_SCRIPTS)
ifneq ($(MAKE4PY_DOCKER_SETUP_SCRIPTS),)
	@cp -a $(MAKE4PY_DOCKER_SETUP_SCRIPTS) $(MAKE4PY_DIR_ABS)/.dockerfiles/
endif
	@docker build --build-arg UBUNTU_VERSION=$* \
	              --build-arg TGT_UID=$(shell id -u) \
	              --build-arg TGT_GID=$(shell id -g) \
	              --build-arg ADDITIONAL_PACKAGES="$(MAKE4PY_DOCKER_PKGS)" \
	              --rm --no-cache \
	              --tag $(MAKE4PY_DOCKER_IMAGE):ubuntu$* \
	              --file $(MAKE4PY_DIR_ABS)/.dockerfiles/Dockerfile.ubuntu \
	              $(MAKE4PY_DIR_ABS)/.dockerfiles
	@$(call MKDIR,$(DOCKER_STAMPS_DIR))
	@touch $@

$(DOCKER_STAMPS_DIR)/$(MAKE4PY_DOCKER_IMAGE)\:alpine%: $(MAKE4PY_DIR_ABS)/.dockerfiles/Dockerfile.alpine $(MAKE4PY_DOCKER_SETUP_SCRIPTS)
ifneq ($(MAKE4PY_DOCKER_SETUP_SCRIPTS),)
	@cp -a $(MAKE4PY_DOCKER_SETUP_SCRIPTS) $(MAKE4PY_DIR_ABS)/.dockerfiles/
endif
	@docker build --build-arg ALPINE_VERSION=$* \
	              --build-arg PYTHON_VERSION=$(ALPINE_PYTHON_VERSION) \
	              --build-arg TGT_UID=$(shell id -u) \
	              --build-arg TGT_GID=$(shell id -g) \
	              --build-arg ADDITIONAL_PACKAGES="$(MAKE4PY_ALPINE_DOCKER_PKGS)" \
	              --rm --no-cache \
	              --tag $(MAKE4PY_DOCKER_IMAGE):alpine$* \
	              --file $(MAKE4PY_DIR_ABS)/.dockerfiles/Dockerfile.alpine \
	              $(MAKE4PY_DIR_ABS)/.dockerfiles
	@$(call MKDIR,$(DOCKER_STAMPS_DIR))
	@touch $@

$(UBUNTU_DOCKER_IMAGES): dockerimage_ubuntu%: $(DOCKER_STAMPS_DIR)/$(MAKE4PY_DOCKER_IMAGE)\:ubuntu%

$(ALPINE_DOCKER_IMAGES): dockerimage_alpine%: $(DOCKER_STAMPS_DIR)/$(MAKE4PY_DOCKER_IMAGE)\:alpine%

clean-dockerimages:
	@$(call RMDIR,$(DOCKER_STAMPS_DIR))
	@docker rmi $(MAKE4PY_UBUNTU_DOCKER_IMAGES) || true
	@docker rmi $(MAKE4PY_ALPINE_DOCKER_IMAGES) || true
	@docker system prune -f                     || true

define UBUNTU_MULTI_PLATFORM_RULE
%.ubuntu$(1): dockerimage_ubuntu$(1)
	@echo "Entering docker environment $(MAKE4PY_DOCKER_IMAGE):ubuntu$(1)..."
	@docker run --rm --user dockeruser \
	            -v $(CURDIR):/workdir \
                    $(PROPAGATE_ARGS) \
	            $(MAKE4PY_DOCKER_IMAGE):ubuntu$(1) \
	            make -C /workdir $$*
	@echo "Leaving docker environment $(MAKE4PY_DOCKER_IMAGE):ubuntu$(1)."
endef

define ALPINE_MULTI_PLATFORM_RULE
%.alpine$(1): dockerimage_alpine$(1)
	@echo "Entering docker environment $(MAKE4PY_DOCKER_IMAGE):alpine$(1)..."
	@docker run --rm --user dockeruser \
	            -v $(CURDIR):/workdir \
                    $(PROPAGATE_ARGS) \
	            $(MAKE4PY_DOCKER_IMAGE):alpine$(1) \
	            make -C /workdir $$*
	@echo "Leaving docker environment $(MAKE4PY_DOCKER_IMAGE):alpine$(1)."
endef

$(foreach UBUNTU_VERSION,$(UBUNTU_DIST_VERSIONS), \
  $(eval $(call UBUNTU_MULTI_PLATFORM_RULE,$(UBUNTU_VERSION))) \
)

$(foreach ALPINE_VERSION,$(ALPINE_DIST_VERSIONS), \
  $(eval $(call ALPINE_MULTI_PLATFORM_RULE,$(ALPINE_VERSION))) \
)

%.ubuntu:
	@for UBUNTU in $(UBUNTU_DIST_VERSIONS); do \
	  $(MAKE) $*.ubuntu$$UBUNTU || exit $?; \
	done

%.alpine:
	@for ALPINE in $(ALPINE_DIST_VERSIONS); do \
	  $(MAKE) $*.alpine$$ALPINE || exit $?; \
	done
endif


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
