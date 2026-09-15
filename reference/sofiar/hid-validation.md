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


## Hardware validation

Validated on physical Moto G8 Power (sofiar) hardware with the NetHunter
development kernel.

Observed Android-visible kernel configuration:

```text
CONFIG_USB_DWC3_DUAL_ROLE=y
CONFIG_USB_F_HID=y
CONFIG_USB_CONFIGFS=y
CONFIG_USB_CONFIGFS_F_HID=y
```

The DWC3 UDC is exposed as:

```text
/sys/class/udc/4e00000.dwc3
```

The phone remained normally responsive during validation. Touch, vibration,
fingerprint, internal Wi-Fi and Bluetooth were operational, and Wi-Fi remained
connected to an access point. Cellular/SIM functionality was not tested because
no SIM was installed.

Status: kernel-side USB HID gadget prerequisites validated on hardware.

Bluetooth being operational is useful for later BLE/IoT security-validation
work, but USB HID gadget support does not by itself imply Bluetooth HID-device
mode. Bluetooth HID must be validated separately at the Android/userspace
profile level.


## Android USB ownership discovered on hardware

Runtime tracing shows that stock Android owns the live USB gadget lifecycle.
The active controller is `4e00000.dwc3`, ConfigFS is enabled, and Android keeps
`sys.usb.config=adb` / `sys.usb.state=adb` during the validated baseline.

The userspace USB HAL is `android.hardware.usb@1.0-service`. Android init imports
`/system/etc/init/hw/init.usb.configfs.rc`, while Motorola adds
`/vendor/etc/init/hw/init.mmi.usb.rc`.

Boot-time dmesg confirms property-driven gadget transitions:

- `sys.usb.config=none && sys.usb.configfs=1` unbinds and tears down the active
  g1 function links.
- `sys.usb.config=adb && sys.usb.configfs=1` rebuilds the Android ADB
  composition.
- once `sys.usb.ffs.ready=1`, the gadget is bound to `4e00000.dwc3` and the
  host enumerates configuration `b`.

This means NetHunter HID integration should not fight the live Android `g1`
object directly. The preferred design is to cooperate with the Android USB
state machine and, if possible after confirming Motorola's init rules, use the
otherwise-unbound `g2` object for the temporary NetHunter HID composition.

Before implementing the switch, inspect the stock system/vendor init rules for
all references to `g2`, `hid`, `UDC`, `sys.usb.config`, and `ffs.adb`.
Do not assume that `g2` is unused until those rules have been checked.
