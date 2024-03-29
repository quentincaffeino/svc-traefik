
###> env ###
## Environment name (leave blank for dev, use prod for production and etc...) [default: ]
ENV ?=

## Path to the dotenv files [default:.]
ENV_PATH ?= .

## List of variables to omit while exporting
SKIP_EXPORT_FOR ?= 

### Load base environment
_ENV_FILES ?= $(ENV_PATH)/.env
ifeq ("$(shell test -e $(ENV_PATH)/.env.local && printf yes)","yes")
	_ENV_FILES += $(ENV_PATH)/.env.local
endif

include $(_ENV_FILES)
VARS := $(filter-out $(SKIP_EXPORT_FOR),$(shell perl -nle 'print $$& while m{^[^\#=]+(?==)(?!.*;)}g' $(_ENV_FILES)))
$(foreach v, $(VARS), $(eval $(shell echo 'export -n $(v); export $(v) = "$($(v))"')))

### Load specific environment
ifneq ($(ENV),)
_ENV_FILES = $(ENV_PATH)/.env.$(ENV)

ifeq ("$(shell test -e $(ENV_PATH)/.env.$(ENV).local && printf yes)","yes")
	_ENV_FILES += $(ENV_PATH)/.env.$(ENV).local
endif

include $(_ENV_FILES)
VARS := $(filter-out $(SKIP_EXPORT_FOR),$(shell perl -nle 'print $$& while m{^[^\#=]+(?==)(?!.*;)}g' $(_ENV_FILES)))
$(foreach v, $(VARS), $(eval $(shell echo 'export -n $(v); export $(v) = "$($(v))"')))
endif
###< env ###
