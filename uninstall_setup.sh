#!/bin/bash

set -e

if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
else
    SUDO="sudo"
fi

echo "Clean aic8800 wifi driver setup files!"
echo "Authentication requested [root] for clean:"

${SUDO} rm -rf /lib/firmware/aic8800DC/
${SUDO} rm -f /etc/udev/rules.d/aic.rules
${SUDO} rm -f /usr/local/bin/aic-msc-eject.sh

if command -v systemctl >/dev/null 2>&1; then
    ${SUDO} systemctl disable aic-msc-eject.service 2>/dev/null || true
    ${SUDO} rm -f /etc/systemd/system/aic-msc-eject.service
    ${SUDO} systemctl daemon-reload
fi

${SUDO} udevadm control --reload

echo "The Uninstall Setup Script is completed!"
