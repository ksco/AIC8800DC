# Shared build configuration for the AIC8800 driver on AOSC / generic Linux.

KVER ?= $(shell uname -r)
KDIR ?= /lib/modules/$(KVER)/build
PWD  ?= $(shell pwd)

MODDESTDIR ?= /lib/modules/$(KVER)/kernel/drivers/net/wireless/aic8800

SUBARCH := $(shell uname -m | sed \
	-e s/i.86/i386/ \
	-e s/armv.l/arm/ \
	-e s/aarch64/arm64/ \
	-e s/loongarch64/loongarch/)
ARCH ?= $(SUBARCH)

CROSS_COMPILE ?=
