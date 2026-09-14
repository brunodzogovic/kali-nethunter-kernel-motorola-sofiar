# sofiar: SYSVIPC versus Android VINTF

The Motorola Moto G8 Power (sofiar) Android 11 stock framework compatibility
matrices require `CONFIG_SYSVIPC=n`. Full Kali NetHunter userspace benefits
from System V IPC, so the NetHunter kernel enables `CONFIG_SYSVIPC=y`.

Enabling SYSVIPC has two independent effects on this device:

1. It changes a large part of the kernel's genksyms CRC set. The stock Motorola
   vendor modules were built against the production CRCs, so the kernel uses
   `CONFIG_MOTO_VENDOR_MODVERSION_COMPAT` to allow only the measured sofiar
   vendor-module allowlist to cross that version mismatch.
2. Android libvintf reads `/proc/config.gz` and compares it with the framework
   compatibility matrix. The stock matrices require SYSVIPC to be disabled, so
   reporting `CONFIG_SYSVIPC=y` causes Android to show the generic
   "There's an internal problem with your device" warning.

`CONFIG_MOTO_VINTF_SYSVIPC_COMPAT` resolves the second conflict without
turning SYSVIPC off. The real build configuration remains unchanged and still
contains `CONFIG_SYSVIPC=y`. Only the embedded IKCONFIG compatibility view
used for `/proc/config.gz` omits that symbol. Android libvintf treats an absent
tristate symbol as `n`.

The authoritative real configuration for a build is therefore the build
directory's `.config`, not `/proc/config.gz`, when this compatibility option
is enabled.

This workaround is intentionally narrow and should not be generalized to other
kernel options without separate validation.
