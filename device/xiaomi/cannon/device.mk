# fstab is installed via TARGET_RECOVERY_FSTAB in BoardConfig.mk

ALLOW_MISSING_DEPENDENCIES := true

# Extra tools in recovery ramdisk
PRODUCT_PACKAGES += \
    fastboot
