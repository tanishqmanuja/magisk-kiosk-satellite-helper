# Kiosk Satellite Root Helper

No Shizuku needed for silent updates on rooted devices.

## What it does

Auto-starts Kiosk Satellite's built-in update helper on boot.

Normally you need to run this after every reboot:

```
adb shell "content read --uri content://me.jxl.kiosk_satellite.update-helper/start | sh"
```

This module does it automatically via root (`service.sh`), so updates stay silent after reboot.

## Install

1. Download `kiosk-satellite-helper-v*.zip` from [Releases](../../releases)
2. Flash in Magisk / KernelSU / APatch → Modules → Install from storage
3. Reboot

Verify: `adb shell cat /data/local/tmp/kiosk-satellite-helper.log`

## Uninstall

Manager → Modules → Remove → Reboot.

## Author

- **tanishqmanuja** — https://github.com/tanishqmanuja
- **Muse Spark** — `muse-spark-1.2-contributor-free` (AI assistant)

## For developers

We use [Conventional Commits](https://www.conventionalcommits.org) (`feat:`, `fix:`) to auto-bump versions.

Release: Actions → Release → Run workflow (dispatch only, `bunx changelogithub` + `bunx changelogen`).

MIT
