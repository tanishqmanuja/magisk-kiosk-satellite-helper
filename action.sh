#!/system/bin/sh
# Triggered by the Action button in Magisk Manager / KSU / APatch
MODDIR=${0%/*}
sh "$MODDIR/service.sh" &
echo "Kiosk Satellite helper running in background..."
echo "Check log: cat /data/local/tmp/kiosk-satellite-helper.log"
sleep 1
cat /data/local/tmp/kiosk-satellite-helper.log 2>/dev/null | tail -n 50
