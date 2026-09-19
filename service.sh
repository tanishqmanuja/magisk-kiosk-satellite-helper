#!/system/bin/sh
# Kiosk Satellite Root Helper - service.sh
# Minimal version: auto-start the bundled update helper on boot so silent
# updates work without ADB after every reboot and without Shizuku.
# This is exactly what docs/updates.md and UpdateHelperProvider.kt:16 expect,
# just run automatically via root instead of manually over ADB.

MODDIR=${0%/*}
PKG="me.jxl.kiosk_satellite"
LOG="/data/local/tmp/kiosk-satellite-helper.log"
TAG="kiosk-satellite-helper"
log() { echo "[$TAG] $1" | tee -a "$LOG"; }

# Wait for boot and for the package's ContentProvider to be available
until [ "$(getprop sys.boot_completed)" = "1" ]; do sleep 2; done
sleep 3
tries=0
until pm path "$PKG" >/dev/null 2>&1; do
  tries=$((tries+1))
  [ $tries -gt 60 ] && { log "package $PKG not found, aborting"; exit 0; }
  sleep 2
done

log "starting update helper via ContentProvider"
# This is the same command the docs tell you to run over ADB:
# adb shell "content read --uri content://me.jxl.kiosk_satellite.update-helper/start | sh"
# Provider checks Binder.getCallingUid() == 0 or 2000 (UpdateHelperProvider.kt:16),
# so su (uid 0) is allowed. No Shizuku needed.
if content read --uri content://me.jxl.kiosk_satellite.update-helper/start 2>>"$LOG" | sh 2>>"$LOG"; then
  log "helper started (or already running)"
else
  log "helper start failed - will retry in 10s"
  sleep 10
  content read --uri content://me.jxl.kiosk_satellite.update-helper/start 2>>"$LOG" | sh 2>>"$LOG" || log "retry failed"
fi

log "done"
