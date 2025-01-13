#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
else
    SUDO="sudo"
fi

echo "##################################################"
echo "AIC8800 setup for AOSC / generic Linux"
echo "##################################################"

# Install firmware.
${SUDO} cp -rf "${SCRIPT_DIR}/fw/aic8800DC" /lib/firmware/

# Install udev rule and helper script.
${SUDO} cp "${SCRIPT_DIR}/tools/aic.rules" /etc/udev/rules.d/
${SUDO} cp "${SCRIPT_DIR}/tools/aic-msc-eject.sh" /usr/local/bin/
${SUDO} chmod +x /usr/local/bin/aic-msc-eject.sh

# Install and enable boot-time eject service.
${SUDO} cp "${SCRIPT_DIR}/tools/aic-msc-eject.service" /etc/systemd/system/
${SUDO} systemctl daemon-reload
${SUDO} systemctl enable aic-msc-eject.service

# Reload udev rules and trigger events for already-connected devices.
${SUDO} udevadm control --reload
${SUDO} udevadm trigger

# Eject the device if it is currently in MSC mode.
if [ -L /dev/aicudisk ]; then
    ${SUDO} /usr/local/bin/aic-msc-eject.sh /dev/aicudisk || true
fi
${SUDO} /usr/local/bin/aic-msc-eject.sh || true
${SUDO} systemctl start aic-msc-eject.service || true

echo "##################################################"
echo "Setup complete."
echo "##################################################"
