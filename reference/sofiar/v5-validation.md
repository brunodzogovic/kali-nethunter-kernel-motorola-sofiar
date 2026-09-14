# sofiar v5 validation milestone

The v5 kernel foundation has been validated on a Motorola Moto G8 Power
(sofiar) running stock Android 11 RPES31.Q4U-47-35-9.

Validated state:

- Bootloader unlocked, active slot B.
- Kernel release remains 4.14.180-perf+.
- CONFIG_SYSVIPC=y is active in the real kernel build.
- The Android-facing IKCONFIG view hides CONFIG_SYSVIPC so stock VINTF
  compatibility matrices continue to see the required n state.
- Motorola stock vendor modules load through the scoped
  CONFIG_MOTO_VENDOR_MODVERSION_COMPAT allowlist.
- Touchscreen, fingerprint, audio, haptics and internal Qualcomm Wi-Fi operate.
- wlan0 reaches UP/LOWER_UP and obtains IPv4 and IPv6 addresses.
- Magisk root has been validated with uid=0 and context u:r:magisk:s0.
- /proc/sysvipc is available and readable with root.
- Android remains responsive and the earlier VINTF "internal problem" warning
  is avoided by the IKCONFIG compatibility view.

The source milestone before MAC80211 is preserved on branch
`milestone-v5-sysvipc-vintf`.

The next development stage adds only the mac80211 foundation required by Kali
NetHunter:

- CONFIG_CFG80211_WEXT=y
- CONFIG_MAC80211=y
- CONFIG_MAC80211_MESH=y

External USB Wi-Fi chipset drivers are intentionally deferred to a later stage
so any regression can be attributed cleanly to the core wireless stack.
