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

%.all:
	@make $(foreach UBUNTU_VERSION,$(UBUNTU_DIST_VERSIONS), \
	  $*.ubuntu$(UBUNTU_VERSION) \
	)
ifeq ($(ENABLE_WINDOWS_SUPPORT),1)
	@make $*.windows
endif

endif


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
