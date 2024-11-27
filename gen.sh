#!/bin/bash

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <xiaomi_defconfig> <gki_defconfig>"
    exit 1
fi

# Input configurations
XIAOMI_CONFIG=$1
GKI_CONFIG=$2

# Temporary files
TEMP_XIAOMI=".xiaomi.config"
TEMP_GKI=".gki.config"

# Ensure the script is run in the kernel source directory
if [ ! -f "scripts/diffconfig" ]; then
    echo "Error: This script must be run from the Linux kernel source root directory."
    exit 1
fi

# Prepare full configs
echo "Preparing full Xiaomi config..."
make $XIAOMI_CONFIG O=out savedefconfig
mv out/defconfig $TEMP_XIAOMI

echo "Preparing full GKI config..."
make $GKI_CONFIG O=out savedefconfig
mv out/defconfig $TEMP_GKI

# Generate the diff
echo "Generating config fragment with Xiaomi-specific changes..."
scripts/diffconfig $TEMP_GKI $TEMP_XIAOMI > xiaomi_fragment.config

# Clean up
rm -f $TEMP_XIAOMI $TEMP_GKI

echo "Config fragment generated: xiaomi_fragment.config"
