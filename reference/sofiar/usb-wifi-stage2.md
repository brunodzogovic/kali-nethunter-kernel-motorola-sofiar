# External USB Wi-Fi stage 2

After validating the MAC80211 baseline and adding RTL8187 support, the next
stage broadens support to several common NetHunter-friendly USB Wi-Fi families.

Enabled in-kernel:

- `CONFIG_ATH9K_HTC=y` for Atheros HTC USB devices such as AR9271.
- `CONFIG_RT2500USB=y` for older Ralink RT2571/RT2572 devices.
- `CONFIG_RT73USB=y` for RT2571W/RT2573/RT2671.
- `CONFIG_RT2800USB=y` for RT2770/RT2870/RT3070/RT3071/RT3072.
- RT2800USB support for RT33xx, RT35xx, RT3573, RT53xx and RT55xx families.

`CONFIG_RT2800USB_UNKNOWN` remains disabled.

Firmware note:

- ath9k_htc devices normally require Atheros HTC firmware such as
  `htc_9271.fw` or `htc_7010.fw`.
- rt73usb normally requires `rt73.bin`.
- rt2800usb devices commonly require Ralink firmware such as `rt2870.bin`.

Firmware delivery is intentionally handled separately from kernel driver
enablement so driver ABI validation and firmware-path validation remain easy to
distinguish.

The previous RTL8187-enabled state is preserved on branch
`milestone-v7-rtl8187`.

Do not enable `CONFIG_CFG80211_WEXT`; Motorola's prebuilt qca_cld3 WLAN
module is ABI-incompatible with that cfg80211 structure layout.
