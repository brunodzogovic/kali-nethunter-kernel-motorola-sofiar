# Sofiar NetHunter USB HID validation

This stage keeps Motorola's existing USB HID gadget support explicit in the
NetHunter development fragment.

Expected kernel configuration:

```text
CONFIG_USB_CONFIGFS=y
CONFIG_USB_F_HID=y
CONFIG_USB_CONFIGFS_F_HID=y
CONFIG_USB_DWC3_DUAL_ROLE=y
```

The purpose of this stage is to verify capability without changing the current
known-good USB composition automatically.

## Runtime checks

After booting the test kernel:

```sh
zcat /proc/config.gz | grep -E 'CONFIG_USB_CONFIGFS=|CONFIG_USB_F_HID=|CONFIG_USB_CONFIGFS_F_HID=|CONFIG_USB_DWC3_DUAL_ROLE='
ls -la /config/usb_gadget 2>/dev/null || true
ls -la /sys/kernel/config/usb_gadget 2>/dev/null || true
ls /sys/class/udc
```

The expected result is that the HID-related options are enabled and at least
one DWC3 UDC is exposed.

Do not replace Android's active gadget configuration during the first check.
The first hardware validation should only confirm that the HID function is
available through ConfigFS and that the existing phone USB functions continue
to operate normally.

Once root/Magisk is preserved in the custom boot image, a separate controlled
test can create a temporary HID keyboard function and send a harmless test
keystroke to a lab host.

## Regression checks

The phone must still retain:

- touch
- internal Wi-Fi
- fingerprint
- audio
- haptics
- USB data/ADB
- stock Motorola vendor modules

Any regression in the stock phone functions blocks promotion of this stage.
