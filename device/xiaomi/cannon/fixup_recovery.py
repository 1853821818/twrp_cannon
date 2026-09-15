#!/usr/bin/env python3
"""Repack the TWRP recovery image to match the stock MIUI/OriginOS v2 layout.

The AOSP build produces a valid v2 image, but it differs from the stock
recovery image (which this device's LK boots reliably) in three ways:

  * no recovery_dtbo section (stock carries a 78798-byte dt_table loaded
    at 0x01FED800),
  * dtb content extracted from the wrong offset in an earlier revision,
    now fixed in prebuilt/dtb.img (real dt_table, 165760 bytes),
  * no padding to the 128MB partition size and no AVB footer, so a partial
    flash leaves the previously flashed image's stale footer in place.

This script rebuilds the final image with the stock field layout, appends
the stock recovery_dtbo and dtb sections verbatim, and pads the file to
the full partition size with an AVB footer so one flash cleanly overwrites
everything, including any stale footer.
"""
import struct

REC = "out/target/product/cannon/recovery.img"
DTBO = "device/xiaomi/cannon/prebuilt/recovery_dtbo.img"
DTB = "device/xiaomi/cannon/prebuilt/dtb.img"
PART_SIZE = 134217728  # BOARD_RECOVERYIMAGE_PARTITION_SIZE

img = open(REC, "rb").read()
assert img[:8] == b"ANDROID!", "not an Android boot image"
ps = struct.unpack_from("<I", img, 36)[0]
assert ps == 2048, ps
ks = struct.unpack_from("<I", img, 8)[0]
rs = struct.unpack_from("<I", img, 16)[0]


def pages(n):
    return (n + ps - 1) // ps


kernel = img[ps:ps + ks]
r_off = ps + ps * pages(ks)
ramdisk = img[r_off:r_off + rs]
print("kernel:", len(kernel), "ramdisk:", len(ramdisk))

dtbo = open(DTBO, "rb").read()
dtb = open(DTB, "rb").read()
assert len(dtbo) == 78798, len(dtbo)
assert len(dtb) == 165760, len(dtb)

# Copy the cmdline / os_version the build system produced; everything else
# is cloned from the stock image header so LK sees a byte-identical layout.
cmdline = img[64:576]
os_version = struct.unpack_from("<I", img, 44)[0]

out = bytearray(1660)  # v2 header
struct.pack_into("<8s", out, 0, b"ANDROID!")
struct.pack_into("<8I", out, 8,
                 len(kernel), 0x40080000,    # kernel size / load addr
                 len(ramdisk), 0x47C80000,   # ramdisk size / load addr
                 0, 0,                        # second size / addr
                 0x4BC80000, 2048)            # tags addr / page size
struct.pack_into("<I", out, 40, 2)             # header_version v2
struct.pack_into("<I", out, 44, os_version)
out[64:576] = cmdline
struct.pack_into("<III", out, 1632, len(dtbo), 0x01FED800, 0)
struct.pack_into("<I", out, 1644, 1660)        # header_size
struct.pack_into("<IQ", out, 1648, len(dtb), 0x4BC80000)

out += b"\x00" * (ps - len(out))  # pad header to end of page 0

for blob in (kernel, ramdisk, dtbo, dtb):
    out += blob
    out += b"\x00" * (ps * pages(len(blob)) - len(blob))
image_size = len(out)
print("repacked image:", image_size, "bytes")

# Pad to the partition size and append a minimal unsigned AVB footer so a
# full-partition flash also overwrites any stale footer left by earlier
# partial flashes. vbmeta_offset is 4096-aligned, as in the stock image.
vb_off = (image_size + 4095) & ~4095
vb = bytearray(256)
vb[0:4] = b"AVB0"
struct.pack_into(">I", vb, 4, 1)     # required_libavb_version_major
struct.pack_into(">I", vb, 8, 2)     # required_libavb_version_minor
struct.pack_into(">I", vb, 0x78, 2)  # flags: verification disabled
vb[128:176] = b"avbtool 1.2.0".ljust(48, b"\x00")
out += b"\x00" * (vb_off - image_size)
out += vb
out += b"\x00" * (PART_SIZE - 64 - len(out))
out += struct.pack(">4sIIQQQ", b"AVBf", 1, 0, image_size, vb_off, len(vb))
out += b"\x00" * 28
assert len(out) == PART_SIZE, len(out)
open(REC, "wb").write(out)
print("final recovery.img:", len(out),
      "bytes (partition-padded, AVB footer written)")
