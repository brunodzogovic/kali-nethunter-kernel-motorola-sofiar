# sofiar HID / USB Arsenal live test

The v8 kernel already contains the required ConfigFS HID gadget support:

- `CONFIG_USB_F_HID=y`
- `CONFIG_USB_CONFIGFS=y`
- `CONFIG_USB_CONFIGFS_F_HID=y`

Android mounts ConfigFS at `/config` and uses `/config/usb_gadget/g1`.
The current gadget is bound to `4e00000.dwc3`.

`tools/sofiar-hid-test.sh` performs a temporary, reboot-safe HID keyboard
experiment. It deliberately refuses to proceed unless the active configuration
already contains the `ffs.adb` function, so ADB is retained when the gadget
is rebound.

The script only modifies the live ConfigFS tree. It does not flash partitions,
modify the boot image, or persist configuration across reboot.

Typical use:

    adb push tools/sofiar-hid-test.sh /data/local/tmp/
    adb shell 'su -c "chmod 755 /data/local/tmp/sofiar-hid-test.sh"'

Because rebinding the USB gadget briefly disconnects ADB, start the enable or
disable operation detached from the USB shell:

    adb shell 'su -c "nohup /data/local/tmp/sofiar-hid-test.sh enable >/data/local/tmp/sofiar-hid.log 2>&1 </dev/null &"'

After USB/ADB reconnects:

    adb wait-for-device
    adb shell 'su -c "cat /data/local/tmp/sofiar-hid.log; ls -l /dev/hidg* 2>/dev/null"'

Rollback uses the same pattern with `disable`.

The HID function is a conventional 8-byte boot-keyboard interface. Sending
actual reports to `/dev/hidgN` is intentionally kept separate from gadget
creation so enumeration can be validated first.
