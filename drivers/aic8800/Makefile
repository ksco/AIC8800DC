# AIC8800 top-level kernel module Makefile.
# Build configuration is shared via config.mk.

# Optional local overrides (gitignored).
-include local.mk

CONFIG_AIC_LOADFW_SUPPORT   := m
CONFIG_AIC8800_WLAN_SUPPORT := m

obj-$(CONFIG_AIC_LOADFW_SUPPORT)   += aic_load_fw/
obj-$(CONFIG_AIC8800_WLAN_SUPPORT) += aic8800_fdrv/

AIC_TOP_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(AIC_TOP_DIR)/config.mk

all: modules

modules:
	$(MAKE) -C $(KDIR) M=$(PWD) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules

install:
	mkdir -p $(MODDESTDIR)
	install -p -m 644 aic_load_fw/aic_load_fw.ko $(MODDESTDIR)/
	install -p -m 644 aic8800_fdrv/aic8800_fdrv.ko $(MODDESTDIR)/
	/sbin/depmod -a $(KVER)

uninstall:
	rm -rfv $(MODDESTDIR)/aic_load_fw.ko
	rm -rfv $(MODDESTDIR)/aic8800_fdrv.ko
	/sbin/depmod -a $(KVER)

clean:
	$(MAKE) -C aic_load_fw clean
	$(MAKE) -C aic8800_fdrv clean
	rm -rf modules.order Module.symvers .tmp_versions/
