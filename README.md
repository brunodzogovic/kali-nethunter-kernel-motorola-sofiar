# Kali NetHunter Kernel for Motorola Moto G8 Power (sofiar)

Community port of the Kali NetHunter kernel for the Motorola Moto G8 Power.

## Target

- Device: Motorola Moto G8 Power
- Model tested: XT2041-3
- Codename: `sofiar`
- Platform: Qualcomm Snapdragon 665 / trinket
- Architecture: ARM64
- Android: 11
- Kernel: Linux 4.14
- Motorola source base: `android-11-release-rpe31.q4u-47-35`
- Stock build tested: `RPES31.Q4U-47-35-9`
- Region tested: RETEU

## Project status

- [x] Identify matching Motorola kernel source
- [x] Capture production kernel configuration
- [ ] Reproduce stock Motorola kernel build
- [ ] Boot self-built stock kernel
- [ ] Add reproducible build environment
- [ ] NetHunter base kernel configuration
- [ ] ConfigFS / HID-4 support
- [ ] Bluetooth RFCOMM
- [ ] USB host / OTG validation
- [ ] ATH9K_HTC
- [ ] RTL8188EUS
- [ ] RTL8812AU / RTL88XXAU
- [ ] Wi-Fi monitor mode and packet injection
- [ ] NetHunter installer package
- [ ] Investigate internal Qualcomm QCACLD monitor mode
- [ ] Upstream submission to Kali NetHunter

## Warning

Experimental kernel development can render a device temporarily
unbootable. Keep a matching stock boot image and working fastboot
environment available before testing builds.

Do not flash images intended for `sofia`; this repository targets
Motorola `sofiar`.

## Source

This repository is based on Motorola Mobility's published Linux kernel
sources. NetHunter-specific modifications will be maintained as distinct
commits on top of the Motorola baseline.
