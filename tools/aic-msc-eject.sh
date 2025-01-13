#!/bin/bash
# Eject AICSemi USB devices that are stuck in mass-storage mode so they
# re-enumerate as Wi-Fi adapters. Called from udev and from the boot service.

AIC_VID="a69c"
AIC_PIDS=("5721" "5722")
TAG="aic-msc-eject"

log() {
    logger -t "$TAG" "$@"
}

eject_block_dev() {
    local dev="$1"
    if [ ! -b "$dev" ]; then
        return
    fi

    log "Ejecting AIC MSC device: $dev"
    # Try standard eject first, then CD-ROM eject for CD-ROM emulated devices.
    if /usr/bin/eject "$dev" 2>/dev/null; then
        log "Ejected $dev with standard eject"
        return
    fi
    if /usr/bin/eject -r "$dev" 2>/dev/null; then
        log "Ejected $dev with CD-ROM eject"
        return
    fi
    log "Failed to eject $dev"
}

# When called from udev, the block device node is passed as argument.
if [ $# -ge 1 ] && [ -b "$1" ]; then
    eject_block_dev "$1"
    exit 0
fi

# Otherwise scan for any connected AIC MSC device and eject it.
# This is used by the boot service to handle devices plugged in at power-on.
for pid in "${AIC_PIDS[@]}"; do
    for id_file in /sys/bus/usb/devices/*/idVendor; do
        [ -r "$id_file" ] || continue
        usb_path="$(dirname "$id_file")"
        [ -r "$usb_path/idProduct" ] || continue

        vid="$(cat "$id_file" 2>/dev/null | tr -d '\n')"
        found_pid="$(cat "$usb_path/idProduct" 2>/dev/null | tr -d '\n')"

        if [ "$vid" = "$AIC_VID" ] && [ "$found_pid" = "$pid" ]; then
            log "Found AIC MSC device $vid:$pid at $usb_path"
            # Find associated block device(s).
            while IFS= read -r block_dir; do
                [ -d "$block_dir" ] || continue
                devname="$(basename "$block_dir")"
                eject_block_dev "/dev/$devname"
            done < <(find "$usb_path" -type d -name block 2>/dev/null)
        fi
    done
done
