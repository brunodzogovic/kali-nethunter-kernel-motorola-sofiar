# sofiar: CFG80211_WEXT is ABI-incompatible with the stock WLAN module

The first MAC80211 experiment enabled:

- CONFIG_CFG80211_WEXT=y
- CONFIG_MAC80211=y
- CONFIG_MAC80211_MESH=y

The kernel booted and the Motorola `wlan` vendor module loaded, but no
`wlan0` interface or wireless phy was registered.

This is not merely a MODVERSIONS CRC mismatch. In this 4.14 source tree,
`CONFIG_CFG80211_WEXT` conditionally adds members to public cfg80211 data
structures used across the driver ABI:

- `struct wiphy` gains the `wext` member.
- `struct wireless_dev` gains an embedded `wext` state block.

Motorola's production kernel was built with `CONFIG_CFG80211_WEXT=n`, and
the prebuilt qca_cld3 WLAN module was compiled against those original structure
layouts. Forcing the module across this structural ABI change lets it load but
does not make the binary layouts compatible.

Therefore sofiar must keep `CONFIG_CFG80211_WEXT=n` while using the stock
Motorola WLAN module.

The next experiment keeps only:

- CONFIG_MAC80211=y
- CONFIG_MAC80211_MESH=y

This retains the modern cfg80211/nl80211 path for external mac80211 USB Wi-Fi
drivers without changing the stock cfg80211 public layouts through WEXT.

The failing source state is preserved on branch
`experiment-v6-cfg80211-wext-broken`.


## v6b validation

The corrected v6b build keeps `CONFIG_CFG80211_WEXT=n` while enabling:

- `CONFIG_MAC80211=y`
- `CONFIG_MAC80211_MESH=y`

Runtime validation on the real sofiar device confirmed:

- Magisk root remains functional.
- The stock Motorola `wlan` module loads.
- `wlan0` is present and reaches UP/LOWER_UP.
- `p2p0` is present.
- The Android-facing kernel config correctly reports
  `# CONFIG_CFG80211_WEXT is not set`.
- mac80211 and Minstrel rate control are active.
- The device remains on the validated 4.14.180-perf+ kernel baseline.

This confirms that MAC80211 itself is compatible with the stock Motorola WLAN
stack on sofiar. The prior regression was specifically caused by enabling
CFG80211_WEXT, which changes cfg80211 public structure layout and is therefore
not safe with Motorola's prebuilt qca_cld3 WLAN module.

The validated source state is preserved on branch
`milestone-v6b-mac80211`.
