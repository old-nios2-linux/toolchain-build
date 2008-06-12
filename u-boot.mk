#
# U-boot Makefile
#

# Source dir.
UBOOTSRC	?= $(TOPDIR)/../u-boot
# Board config
UBOOT_BOARD	?=
# Build dir.
UBOOT_BUILD	= $(BUILDDIR)/u-boot

# Misc.
UBOOT_ARCH	= nios2
ifeq ($(UBOOT_BOARD),)
$(warning Board not defined! Using EP1S10 as default.)
UBOOT_BOARD	= EP1S10
endif
UBOOT_CONFIG	= $(UBOOT_BOARD)_config

# U-boot
u-boot_config: $(UBOOT_BUILD)/.configured
$(UBOOT_BUILD)/.configured:
	PATH=$(TARGET_PATH):$(PATH) \
	$(MAKE) O=$(UBOOT_BUILD) -C $(UBOOTSRC) CROSS_COMPILE=$(TARGET_NAME)- ARCH=$(UBOOT_ARCH) $(UBOOT_CONFIG)
	touch $@

u-boot: $(UBOOT_BUILD)/u-boot.bin
$(UBOOT_BUILD)/u-boot.bin: $(UBOOT_BUILD)/.configured
	PATH=$(TARGET_PATH):$(PATH) \
	$(MAKE) O=$(UBOOT_BUILD) -C $(UBOOTSRC) CROSS_COMPILE=$(TARGET_NAME)- ARCH=$(UBOOT_ARCH)
	touch $@

# Tools
$(UBOOT_BUILD)/.tools_configured:
	PATH=$(TARGET_PATH):$(PATH) \
	$(MAKE) O=$(UBOOT_BUILD) -C $(UBOOTSRC) CROSS_COMPILE= ARCH=$(UBOOT_ARCH) $(UBOOT_CONFIG)
	touch $@

u-boot-tools: $(UBOOT_BUILD)/tools/mkimage
	cp -f  $(UBOOT_BUILD)/tools/mkimage $(INSTALLDIR)/bin/mkimage

$(UBOOT_BUILD)/tools/mkimage: $(UBOOT_BUILD)/.tools_configured
	PATH=$(TARGET_PATH):$(PATH) \
	$(MAKE) O=$(UBOOT_BUILD) -C $(UBOOTSRC) tools
	touch $@

# Clean
u-boot-clean:
	PATH=$(TARGET_PATH):$(PATH) \
	$(MAKE) O=$(UBOOT_BUILD) -C $(UBOOTSRC) ARCH=$(UBOOT_ARCH) clean
	rm -f $(UBOOT_BUILD)/.tools_configured $(UBOOT_BUILD)/.configured

u-boot-distclean:
	rm -rf $(UBOOT_BUILD)
