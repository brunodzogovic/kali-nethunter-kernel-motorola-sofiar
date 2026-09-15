#!/system/bin/sh
#
# Temporary/reversible HID keyboard function test for Motorola sofiar.
# Run as root. This modifies only the live ConfigFS gadget and is lost on reboot.
#

set -eu

G=/config/usb_gadget/g1
CFG=b.1
FUNC=hid.keyboard
LINK=f_hid

log() { echo "[sofiar-hid] $*"; }
die() { echo "[sofiar-hid] ERROR: $*" >&2; exit 1; }

[ "$(id -u)" = "0" ] || die "must run as root"
[ -d "$G" ] || die "$G does not exist"
[ -d "$G/configs/$CFG" ] || die "configuration $CFG does not exist"

has_adb=0
for l in "$G/configs/$CFG"/*; do
    [ -L "$l" ] || continue
    case "$(readlink "$l" 2>/dev/null || true)" in
        *ffs.adb*) has_adb=1 ;;
    esac
done
[ "$has_adb" = "1" ] || die "active config does not contain ffs.adb; refusing to risk ADB"

UDC="$(cat "$G/UDC" 2>/dev/null || true)"
if [ -z "$UDC" ]; then
    UDC="$(ls /sys/class/udc 2>/dev/null | head -n 1 || true)"
fi
[ -n "$UDC" ] || die "no UDC found"

unbind() {
    if [ -n "$(cat "$G/UDC" 2>/dev/null || true)" ]; then
        log "unbinding $UDC"
        printf '\n' > "$G/UDC"
        sleep 1
    fi
}

bind() {
    log "binding $UDC"
    echo "$UDC" > "$G/UDC"
}

enable_hid() {
    if [ -L "$G/configs/$CFG/$LINK" ]; then
        log "HID link already present"
        return 0
    fi

    unbind

    if [ ! -d "$G/functions/$FUNC" ]; then
        mkdir "$G/functions/$FUNC"
    fi

    # USB HID boot keyboard: 8-byte reports.
    echo 1 > "$G/functions/$FUNC/protocol"
    echo 1 > "$G/functions/$FUNC/subclass"
    echo 8 > "$G/functions/$FUNC/report_length"

    # Standard 63-byte keyboard report descriptor, expressed with octal escapes
    # for compatibility with Android's /system/bin/sh.
    printf '\005\001\011\006\241\001\005\007\031\340\051\347\025\000\045\001\165\001\225\010\201\002\225\001\165\010\201\001\225\005\165\001\005\010\031\001\051\005\221\002\225\001\165\003\221\001\225\006\165\010\025\000\045\145\005\007\031\000\051\145\201\000\300' \
        > "$G/functions/$FUNC/report_desc"

    (
        cd "$G"
        ln -s "functions/$FUNC" "configs/$CFG/$LINK"
    )

    bind
    log "HID keyboard enabled"
}

disable_hid() {
    unbind

    if [ -L "$G/configs/$CFG/$LINK" ]; then
        rm "$G/configs/$CFG/$LINK"
    fi
    if [ -d "$G/functions/$FUNC" ]; then
        rmdir "$G/functions/$FUNC" 2>/dev/null || true
    fi

    bind
    log "HID keyboard disabled"
}

case "${1:-enable}" in
    enable) enable_hid ;;
    disable) disable_hid ;;
    *)
        echo "usage: $0 [enable|disable]" >&2
        exit 2
        ;;
esac
