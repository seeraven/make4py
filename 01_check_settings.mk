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
#  CHECK MANDATORY USER SETTINGS
# ----------------------------------------------------------------------------

ifndef APP_NAME
$(error Variable APP_NAME is not set!)
endif

ifndef APP_VERSION
$(error Variable APP_VERSION is not set!)
endif


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
