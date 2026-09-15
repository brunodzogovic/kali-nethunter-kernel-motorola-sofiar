# External USB Wi-Fi stage 1: RTL8187

The first external USB Wi-Fi target for sofiar is the in-tree RTL8187 driver.

Configuration:

- `CONFIG_RTL8187=y`

Rationale:

- It uses the already validated mac80211/cfg80211 stack.
- It is a USB-native driver.
- It does not require an external firmware blob, avoiding firmware-path issues
  during the first NetHunter external-radio validation.
- Building it into the kernel avoids Android module-installation and module
  loading complications while the platform is still under development.

The known-good pre-driver baseline remains preserved on
`milestone-v6b-mac80211`.

Keep `CONFIG_CFG80211_WEXT=n`; the Motorola stock qca_cld3 WLAN module is ABI
incompatible with a kernel built with CFG80211_WEXT enabled.
