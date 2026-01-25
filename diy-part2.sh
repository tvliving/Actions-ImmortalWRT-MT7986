#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate


# --------------------------------------------------------------------
# Security Hardening: Inject SmartDNS cache_persist protection script
# 
# It effectively prevents the flash P/E Flood risk on first boot caused by cache_persist being enabled by default.
# --------------------------------------------------------------------

echo "Writing SmartDNS protection script (00-highest-priority)..."
mkdir -p files/etc/uci-defaults/
cat > files/etc/uci-defaults/00-disable-smartdns-cache <<'EOF_SCRIPT'
#!/bin/sh
# ----------------------------------------------------------------------
# Script for OpenWrt uci-defaults
# Purpose: First-boot hardening to disable smartdns cache_persist.
# ----------------------------------------------------------------------

logger "Executing CRITICAL first-boot fix: Disabling SmartDNS cache_persist to protect flash."

uci set smartdns.@smartdns[0].cache_persist='0'
uci commit smartdns

logger "SmartDNS first-boot hardening script finished successfully."
exit 0
EOF_SCRIPT

echo "Setting executable permissions for the protection script..."
chmod +x files/etc/uci-defaults/00-disable-smartdns-cache

echo "SmartDNS protection script has been successfully added to the build environment."

# --------------------------------------------------------------------
# End of Security Hardening Section
# --------------------------------------------------------------------
