#!/system/bin/sh
# Magisk installer - customize.sh
ui_print "****************************************"
ui_print "  Kiosk Satellite Root Helper"
ui_print "  No Shizuku needed for silent updates"
ui_print "****************************************"

if [ -z "$MAGISK_VER_CODE" ] && [ -z "$KSU" ] && [ -z "$APATCH" ]; then
  ui_print "! Requires Magisk 20.4+, KernelSU or APatch"
  abort
fi

set_perm_recursive "$MODPATH" 0 0 0755 0644 2>/dev/null || true
[ -f "$MODPATH/service.sh" ] && set_perm "$MODPATH/service.sh" 0 0 0755 2>/dev/null || chmod 0755 "$MODPATH/service.sh"
[ -f "$MODPATH/action.sh" ] && set_perm "$MODPATH/action.sh" 0 0 0755 2>/dev/null || chmod 0755 "$MODPATH/action.sh"
[ -f "$MODPATH/uninstall.sh" ] && set_perm "$MODPATH/uninstall.sh" 0 0 0755 2>/dev/null || chmod 0755 "$MODPATH/uninstall.sh"

ui_print "- Installed to $MODPATH"
ui_print "- Helper auto-starts on boot (service.sh)"
ui_print "- Manual run: su -c sh /data/adb/modules/kiosk-satellite-helper/service.sh"
ui_print "- Log: cat /data/local/tmp/kiosk-satellite-helper.log"
