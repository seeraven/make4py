# ----------------------------------------------------------------------------
# Makefile part of make4py
#
# Copyright (c) 2023 by Clemens Rabe <clemens.rabe@clemensrabe.de>
# All rights reserved.
# This file is part of make4py (https://github.com/seeraven/make4py)
# and is released under the "BSD 3-Clause License". Please see the LICENSE file
# that is included as part of this package.
# ----------------------------------------------------------------------------


.PHONY: print_appname print_version

print_appname:
	@echo $(APP_NAME)

print_version:
	@echo $(APP_VERSION)


ifneq ($(DOC_SUPPORT),)

.PHONY: apidoc doc man

ifeq ($(SWITCH_TO_VENV),1)

apidoc: apidoc.venv
doc: doc.venv
man: man.venv

else

apidoc:
	@$(call RMDIR,doc/source/apidoc)
	@$(SET_PYTHONPATH) sphinx-apidoc -f -M -T -o doc/source/apidoc $(DOC_MODULES)

doc: apidoc
	@$(SET_PYTHONPATH) sphinx-build -W -b html doc/source doc/build

man:
	@$(SET_PYTHONPATH) sphinx-build -W -b man doc/manpage doc/build

endif

endif


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
