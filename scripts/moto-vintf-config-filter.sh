#!/bin/sh
#
# Produce the IKCONFIG view exposed through /proc/config.gz for Motorola
# sofiar NetHunter builds.
#
# The real kernel is built with CONFIG_SYSVIPC=y.  Stock Android 11 VINTF
# matrices for sofiar require CONFIG_SYSVIPC=n.  libvintf treats an absent
# tristate symbol as n, so omit only this one line from the compatibility
# view while leaving the authoritative build .config untouched.
#

set -eu

if [ "$#" -ne 1 ]; then
    echo "usage: $0 <kernel-config>" >&2
    exit 2
fi

config=$1

if [ ! -r "$config" ]; then
    echo "moto-vintf-config-filter: cannot read $config" >&2
    exit 1
fi

printf '%s\n' '# NetHunter VINTF compatibility view: CONFIG_SYSVIPC is enabled in the running kernel'
grep -v '^CONFIG_SYSVIPC=y$' "$config"
