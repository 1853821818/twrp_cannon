# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

# Inherit from our custom product configuration
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit from cannon device
$(call inherit-product, device/xiaomi/cannon/device.mk)

# Device identifier. This must come after all inclusions
PRODUCT_DEVICE := cannon
PRODUCT_NAME := twrp_cannon
PRODUCT_BRAND := Redmi
PRODUCT_MODEL := M2007J22C
PRODUCT_MANUFACTURER := Xiaomi
