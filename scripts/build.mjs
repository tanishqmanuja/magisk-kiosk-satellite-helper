#!/usr/bin/env node
// Build transparent Magisk module zip for current version
import { execSync } from 'node:child_process'
import { readFileSync, existsSync, rmSync } from 'node:fs'

const pkg = JSON.parse(readFileSync('package.json', 'utf8'))
const version = pkg.version.replace(/^v/, '')
const tag = `v${version}`
const zipName = `kiosk-satellite-helper-${tag}.zip`

if (existsSync(zipName)) rmSync(zipName)

// Ensure LF line endings before zipping (Magisk requires Unix)
try {
  execSync(`git add --renormalize .`, { stdio: 'ignore' })
} catch {}

const files = [
  'module.prop',
  'service.sh',
  'customize.sh',
  'action.sh',
  'uninstall.sh',
  'META-INF',
  'README.md',
  'CHANGELOG.md',
]

const cmd = `zip -r9 ${zipName} ${files.join(' ')} -x "*.git*" "*.DS_Store*" "package*.json" "node_modules/*" "scripts/*" ".github/*"`
console.log(`> ${cmd}`)
execSync(cmd, { stdio: 'inherit' })
console.log(`Built ${zipName} (${(process.stdout, readFileSync(zipName).length)} bytes)`)

// Also print sha256 for transparency
try {
  const sha = execSync(`sha256sum ${zipName} 2>/dev/null || shasum -a 256 ${zipName}`, { encoding: 'utf8' })
  console.log(sha.trim())
} catch {}
