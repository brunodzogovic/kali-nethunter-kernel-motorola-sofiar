# sofiar v8 validation milestone

The v8 NetHunter kernel stage broadens external USB Wi-Fi support while
preserving the previously validated Motorola stock hardware stack.

Validated runtime state:

- Magisk root works with uid=0 and SELinux context u:r:magisk:s0.
- Internal Motorola/Qualcomm WLAN remains functional.
- wlan0 is present and reaches UP/LOWER_UP.
- p2p0 is present.
- phy0 is registered at the internal Qualcomm ICNSS device.
- CONFIG_CFG80211_WEXT remains disabled to preserve the prebuilt Motorola
  qca_cld3 cfg80211 ABI.
- CONFIG_MAC80211 remains enabled.
- RTL8187 support is built in and registered.
- ath9k_htc support is built in and registered.
- rt2500usb support is built in and registered.
- rt73usb support is built in and registered.
- rt2800usb support is built in and registered.
- RT2800USB support for RT33xx, RT35xx, RT3573, RT53xx and RT55xx families is
  enabled.
- No external adapter is required for this validation; driver registration and
  preservation of the internal WLAN path are the milestone criteria.

Observed registration messages include:

    usbcore: registered new interface driver ath9k_htc
    usbcore: registered new interface driver rt2500usb
    usbcore: registered new interface driver rt73usb
    usbcore: registered new interface driver rt2800usb
    usbcore: registered new interface driver rtl8187

Firmware-requiring adapters will be validated separately when matching USB
hardware is attached. The kernel's stock firmware loader remains enabled.

The validated source state is preserved on branch
`milestone-v8-common-usb-wifi`.

## Next stage

The stock sofiar kernel already provides the ConfigFS HID gadget pieces needed
for NetHunter HID work:

- CONFIG_USB_F_HID=y
- CONFIG_USB_CONFIGFS=y
- CONFIG_USB_CONFIGFS_F_HID=y

Therefore the next HID/USB-Arsenal work is primarily userspace/configfs
orchestration rather than another kernel feature enablement.
