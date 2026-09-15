LOCAL_PATH := device/xiaomi/cannon

DEVICE_PATH := device/xiaomi/cannon

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a55
TARGET_CPU_VARIANT_RUNTIME := cortex-a55

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := cannon
TARGET_BOARD_PLATFORM := mt6853
TARGET_NO_BOOTLOADER := true

# Kernel (prebuilt from stock MIUI V14.0.6.0.SJECNXM recovery.img, Linux 4.14.186)
TARGET_PREBUILT_KERNEL := $(LOCAL_PATH)/prebuilt/Image.gz
BOARD_KERNEL_IMAGE_NAME := Image.gz
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2 buildvariant=user androidboot.selinux=permissive
BOARD_KERNEL_BASE := 0x40078000
BOARD_KERNEL_PAGESIZE := 2048
# Match the stock boot image layout exactly: header v2 with a separate DTB section
# (dtb_addr = tags_addr = 0x4bc80000). This LK does not boot the legacy v0 format
# with a kernel-embedded dtb - it fails and falls back to the system.
BOARD_MKBOOTIMG_ARGS := --header_version 2 --kernel_offset 0x00008000 --ramdisk_offset 0x07c08000 --tags_offset 0x0bc08000 --dtb $(LOCAL_PATH)/prebuilt/dtb.img --dtb_offset 0x0bc08000 --board ""

# AVB
BOARD_AVB_ENABLE := false

# Partitions
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 134217728
BOARD_USES_RECOVERY_AS_BOOT := false

# Dynamic partitions (vendor/product are logical partitions inside super,
# so their ramdisk roots must be mount-point directories, not symlinks)
TARGET_USES_DYNAMIC_PARTITIONS := true
BOARD_USES_VENDORIMAGE := true
BOARD_USES_PRODUCTIMAGE := true
BOARD_SUPER_PARTITION_SIZE := 9126805504
BOARD_SUPER_PARTITION_GROUPS := mtk_dynamic_partitions
BOARD_MTK_DYNAMIC_PARTITIONS_SIZE := 9122611200
BOARD_MTK_DYNAMIC_PARTITIONS_PARTITION_LIST := system vendor product

# Filesystems
BOARD_HAS_LARGE_FILESYSTEM := true
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
TARGET_USES_MKE2FS := true

# Metadata
BOARD_USES_METADATA_PARTITION := true

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_FSTAB := $(LOCAL_PATH)/recovery/root/system/etc/recovery.fstab
AB_OTA_UPDATER := false

# Workaround build errors
BUILD_BROKEN_DUP_SYMS := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Platform version (must be >= ROM level for FBE keymaster)
PLATFORM_VERSION := 12.0.0
PLATFORM_SECURITY_PATCH := 2023-10-01
VENDOR_SECURITY_PATCH := 2023-10-01

# TWRP configuration
TW_THEME := portrait_hdpi
TW_DEVICE_VERSION := 1

RECOVERY_SDCARD_ON_DATA := true
BOARD_SUPPRESS_SECURE_ERASE := true

# Crypto (FBE v1 on f2fs, as shipped by this ROM)
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true

# UI / misc
TW_EXTRA_LANGUAGES := true
TW_INCLUDE_NTFS_3G := true
TW_INCLUDE_REPACKTOOLS := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_USE_MODEL_HARDWARE_ID_FOR_DEVICE_ID := true
TW_BRIGHTNESS_PATH := /sys/class/leds/lcd-backlight/brightness
TW_MAX_BRIGHTNESS := 2047
TW_DEFAULT_BRIGHTNESS := 1024
TW_CUSTOM_BATTERY_PATH := /sys/class/power_supply/battery
