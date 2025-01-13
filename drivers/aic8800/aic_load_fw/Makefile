# AIC8800 firmware loader module Makefile.

# Optional local overrides (gitignored).
-include $(dir $(abspath $(lastword $(MAKEFILE_LIST))))/../local.mk

ccflags-y += -Wno-missing-prototypes -Wno-discarded-qualifiers -Wno-error

CONFIG_USB_SUPPORT          = y
CONFIG_RFTEST               = y
CONFIG_USB_BT               = y
CONFIG_USB_MSG_EP           = y
CONFIG_USB_NO_TRANS_DMA_MAP = n
CONFIG_M2D_OTA_AUTO_SUPPORT = n
CONFIG_LINK_DET_5G          = y
CONFIG_USE_FW_REQUEST       = n
CONFIG_PREALLOC_RX_SKB      = n
CONFIG_PREALLOC_TXQ         = y

CONFIG_AIC_LOADFW_SUPPORT = m
MODULE_NAME = aic_load_fw

ccflags-$(CONFIG_USB_SUPPORT)          += -DAICWF_USB_SUPPORT
ccflags-$(CONFIG_RFTEST)               += -DCONFIG_RFTEST
ccflags-$(CONFIG_USB_BT)               += -DCONFIG_USB_BT
ccflags-$(CONFIG_USB_MSG_EP)           += -DCONFIG_USB_MSG_EP
ccflags-$(CONFIG_USB_NO_TRANS_DMA_MAP) += -DCONFIG_USB_NO_TRANS_DMA_MAP
ccflags-$(CONFIG_M2D_OTA_AUTO_SUPPORT) += -DCONFIG_M2D_OTA_AUTO_SUPPORT
ccflags-$(CONFIG_LINK_DET_5G)          += -DCONFIG_LINK_DET_5G
ccflags-$(CONFIG_USE_FW_REQUEST)       += -DCONFIG_USE_FW_REQUEST
ccflags-$(CONFIG_PREALLOC_RX_SKB)      += -DCONFIG_PREALLOC_RX_SKB
ccflags-$(CONFIG_PREALLOC_TXQ)         += -DCONFIG_PREALLOC_TXQ

obj-$(CONFIG_AIC_LOADFW_SUPPORT) := $(MODULE_NAME).o
$(MODULE_NAME)-y := \
	aic_bluetooth_main.o \
	aicbluetooth.o \
	aicwf_usb.o \
	aic_txrxif.o \
	aicbluetooth_cmds.o \
	md5.o

$(MODULE_NAME)-$(CONFIG_PREALLOC_RX_SKB) += aicwf_rx_prealloc.o
$(MODULE_NAME)-$(CONFIG_PREALLOC_TXQ)   += aicwf_txq_prealloc.o

AIC_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(AIC_DIR)/../config.mk

ccflags-y += -DCONFIG_PLATFORM_UBUNTU

all: modules

modules:
	$(MAKE) -C $(KDIR) M=$(PWD) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules

install:
	mkdir -p $(MODDESTDIR)
	install -p -m 644 $(MODULE_NAME).ko $(MODDESTDIR)/
	/sbin/depmod -a $(KVER)

uninstall:
	rm -rfv $(MODDESTDIR)/$(MODULE_NAME).ko
	/sbin/depmod -a $(KVER)

clean:
	rm -rf *.o *.ko *.o.* *.mod.* modules.* Module.* .a* .o* .*.o.* *.mod .tmp* .cache.mk
