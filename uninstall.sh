#!/system/bin/sh
# Cleanup on module uninstall - nothing destructive.
# We do NOT revoke permissions; user can keep them.
rm -f /data/local/tmp/kiosk-satellite-helper.log
rm -f /data/local/tmp/ks-shizuku-update-* 2>/dev/null
echo "Kiosk Satellite Root Helper uninstalled" > /data/local/tmp/kiosk-satellite-helper-uninstall.log 2>&1 || true
