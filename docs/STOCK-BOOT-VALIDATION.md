# Stock Kernel Boot Validation

## Target

- Device: Motorola Moto G8 Power
- Model: XT2041-3
- Codename: sofiar
- Product: sofiar_reteu
- Android: 11
- Firmware: RPES31.Q4U-47-35-9
- Incremental: 54bc43
- Kernel release: 4.14.180-perf+
- Active slot during validation: B
- Bootloader state: flashing_unlocked

## Stock baseline validation

The production kernel configuration was captured from the device and
reproduced from the Motorola kernel source.

`scripts/diffconfig` between the production configuration and the clean
build configuration produced no differences.

Kernel release:

    4.14.180-perf+

A clean build successfully generated:

- Image
- Image.gz
- trinket-sofiar-base.dtb
- Motorola sofiar DTBO overlays
- kernel modules

## Boot image analysis

The active stock boot image uses:

- Android boot header version 2
- page size: 4096
- Android version: 11.0.0
- security patch level: 2021-10
- gzip-compressed kernel
- gzip-compressed ramdisk
- separate DTB
- DTB load address: 0x01f00000

The DTB extracted from the active Motorola boot image was byte-for-byte
identical to the DTB produced by the clean local kernel build.

DTB SHA256:

    10c0ba3667753077e7107604c375588201c0b9966d3f9e29139ef3494fd3adb4

## Hardware boot validation

A test boot image was constructed using:

- Motorola stock boot header
- Motorola stock command line
- Motorola stock ramdisk
- Motorola stock DTB
- locally compiled Image.gz

The image was booted temporarily using:

    fastboot boot out/boot-b-selfbuilt-kernel.img

No boot partition was flashed.

Android successfully booted using the locally compiled kernel.

Observed on-device:

    Linux localhost 4.14.180-perf+ #1 SMP PREEMPT Sun Sep 13 23:29:11 CEST 2026 aarch64

/proc/version:

    Linux version 4.14.180-perf+ (bruno@elitebook-mint) (Android (6051079 based on r370808) clang version 10.0.1 (https://android.googlesource.com/toolchain/llvm-project b9738d6d99f614c8bf7a3e7c769659b313b88244), GNU ld (GNU Binutils) 2.24) #1 SMP PREEMPT Sun Sep 13 23:29:11 CEST 2026

Android userspace remained:

    RPES31.Q4U-47-35-9

This establishes a known-good, hardware-validated Motorola stock kernel
baseline before NetHunter-specific changes are introduced.
