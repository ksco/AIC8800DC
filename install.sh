#!/bin/bash
set -xe

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRIVER_DIR="${SCRIPT_DIR}/drivers/aic8800"

KVER="$(uname -r)"
KDIR="/lib/modules/${KVER}/build"

echo "##################################################"
echo "AIC8800DC/DW Wi-Fi Driver Installer"
echo "Target kernel: ${KVER}"
echo "##################################################"

if [ ! -d "${KDIR}" ]; then
    echo "ERROR: Kernel headers not found at ${KDIR}"
    echo "Please install the kernel headers for ${KVER} and try again."
    exit 1
fi

if ! command -v make >/dev/null 2>&1; then
    echo "ERROR: 'make' is not installed."
    exit 1
fi

cd "${DRIVER_DIR}"

echo "[1/5] Cleaning previous build artifacts..."
make clean >/dev/null 2>&1 || true

echo "[2/5] Building driver modules for kernel ${KVER}..."
make -j4 KVER="${KVER}" KDIR="${KDIR}" modules

echo "[3/5] Installing driver modules..."
if [ "$(id -u)" -eq 0 ]; then
    make KVER="${KVER}" install
else
    sudo make KVER="${KVER}" install
fi

echo "[4/5] Installing firmware and udev rules..."
cd "${SCRIPT_DIR}"
if [ "$(id -u)" -eq 0 ]; then
    ./install_setup.sh
else
    sudo ./install_setup.sh
fi

echo "[5/5] Loading modules..."
if [ "$(id -u)" -eq 0 ]; then
    modprobe aic_load_fw || true
    modprobe aic8800_fdrv || true
else
    sudo modprobe aic_load_fw || true
    sudo modprobe aic8800_fdrv || true
fi

echo "##################################################"
echo "Installation complete!"
echo "Kernel: ${KVER}"
echo "Modules:"
echo "  $(modinfo -n aic_load_fw 2>/dev/null || echo '  aic_load_fw not found in modprobe output')"
echo "  $(modinfo -n aic8800_fdrv 2>/dev/null || echo '  aic8800_fdrv not found in modprobe output')"
echo "##################################################"
