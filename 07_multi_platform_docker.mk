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
UBUNTU_DOCKER_IMAGES  := $(addprefix dockerimage_ubuntu,$(UBUNTU_DIST_VERSIONS))
DOCKER_STAMPS_DIR     := $(or $(DOCKER_STAMPS_DIR),$(CURDIR)/.dockerstamps)
MAKE4PY_DOCKER_IMAGE  := $(or $(MAKE4PY_DOCKER_IMAGE),make4py)
MAKE4PY_DOCKER_IMAGES := $(addprefix $(MAKE4PY_DOCKER_IMAGE):ubuntu,$(UBUNTU_DIST_VERSIONS))

.PHONY: $(UBUNTU_DOCKER_IMAGES) clean-dockerimages

$(DOCKER_STAMPS_DIR)/$(MAKE4PY_DOCKER_IMAGE)\:ubuntu%: $(MAKE4PY_DIR_ABS)/.dockerfiles/Dockerfile.ubuntu
	@docker build --build-arg UBUNTU_VERSION=$* \
	              --build-arg TGT_UID=$(shell id -u) \
	              --build-arg TGT_GID=$(shell id -g) \
	              --rm --no-cache \
	              --tag $(MAKE4PY_DOCKER_IMAGE):ubuntu$* \
	              --file $(MAKE4PY_DIR_ABS)/.dockerfiles/Dockerfile.ubuntu \
	              $(MAKE4PY_DIR_ABS)/.dockerfiles
	@$(call MKDIR,$(DOCKER_STAMPS_DIR))
	@touch $@

$(UBUNTU_DOCKER_IMAGES): dockerimage_ubuntu%: $(DOCKER_STAMPS_DIR)/$(MAKE4PY_DOCKER_IMAGE)\:ubuntu%

clean-dockerimages:
	@$(call RMDIR,$(DOCKER_STAMPS_DIR))
	@docker rmi $(MAKE4PY_DOCKER_IMAGES) || true
	@docker system prune -f              || true

define MULTI_PLATFORM_RULE =
%.ubuntu$(1): dockerimage_ubuntu$(1)
	docker run --rm --user dockeruser \
	            -v $(CURDIR):/workdir \
	            $(MAKE4PY_DOCKER_IMAGE):ubuntu$(1) \
	            make -C /workdir $$*
endef

$(foreach UBUNTU_VERSION,$(UBUNTU_DIST_VERSIONS), \
  $(eval $(call MULTI_PLATFORM_RULE,$(UBUNTU_VERSION))) \
)

endif


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
