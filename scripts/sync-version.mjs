#!/usr/bin/env node
// Sync package.json version -> module.prop version + versionCode + update.json
import { readFileSync, writeFileSync } from 'node:fs'

const pkg = JSON.parse(readFileSync('package.json', 'utf8'))
const version = pkg.version.replace(/^v/, '')
const tag = `v${version}`

// versionCode: major*10000 + minor*100 + patch (e.g. 1.2.3 -> 10203)
// For 1.0.0 -> 10000, keeps monotonic for Magisk versionCode integer
function toVersionCode(v) {
  const [major = 0, minor = 0, patch = 0] = v.split('.').map(n => parseInt(n, 10) || 0)
  return major * 10000 + minor * 100 + patch
}
const versionCode = toVersionCode(version)

// Update module.prop
let prop = readFileSync('module.prop', 'utf8')
prop = prop.replace(/^version=.*$/m, `version=${tag}`)
prop = prop.replace(/^versionCode=.*$/m, `versionCode=${versionCode}`)
writeFileSync('module.prop', prop)
console.log(`module.prop -> version=${tag} versionCode=${versionCode}`)

// Update update.json
try {
  const update = JSON.parse(readFileSync('update.json', 'utf8'))
  const repo = pkg.repository?.url?.replace(/^.*github\.com[:/](.+?)(\.git)?$/, '$1') || 'tanishqmanuja/kiosk-satellite-helper'
  update.version = tag
  update.versionCode = versionCode
  update.zipUrl = `https://github.com/${repo}/releases/download/${tag}/kiosk-satellite-helper-${tag}.zip`
  update.changelog = `https://github.com/${repo}/releases/tag/${tag}`
  writeFileSync('update.json', JSON.stringify(update, null, 2) + '\n')
  console.log(`update.json -> ${update.zipUrl}`)
} catch (e) {
  console.warn('update.json not found or invalid, skipping', e.message)
}
