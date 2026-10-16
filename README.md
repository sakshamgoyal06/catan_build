# Hexwild

Original hex territory board game (Catan-style structure, own names and art). **Installable web app (PWA)** with auto-deploy from GitHub, plus native Android/iOS for full nearby hosting.

## Install on your phone (recommended)

After GitHub Pages is enabled (see below), open:

**https://sakshamgoyal06.github.io/catan_build/**

| Platform | Install steps |
|----------|----------------|
| **iPhone (Safari)** | Open the URL → Share → **Add to Home Screen** |
| **Android (Chrome)** | Open the URL → menu → **Install app** or **Add to Home screen** |

The icon opens like a normal app (no browser chrome). When you push to `main`, GitHub Actions rebuilds the site; **close and reopen** the app (or refresh once) to pick up updates.

## One-time GitHub setup (auto-updates)

1. Merge/deploy to **`main`** (the workflow runs on every push to `main`).
2. Repo **Settings → Pages → Build and deployment → Source:** choose **GitHub Actions** (not “Deploy from branch”).
3. After the first successful workflow run, your Pages URL is live.

Workflow file: `.github/workflows/deploy-web-pwa.yml`

## Run locally (web)

```bash
cd apps/mobile
flutter pub get
flutter run -d chrome
# production-like build:
flutter build web --release --base-href "/catan_build/" --pwa-strategy offline-first
# serve build/web with any static server for testing install prompts
```

## Run locally (native — full nearby host)

```bash
cd apps/mobile
flutter pub get
flutter run   # phone or emulator
```

Nearby MVP on **native**: host opens LAN WebSocket on port **8765**; friends join with host IP. **Web PWA** uses a **solo demo board** (browsers cannot host LAN servers); use native builds to host for friends.

## Rules package tests

```bash
cd packages/hexwild_rules && dart test
```

## Repo layout

```
apps/mobile/             Flutter app (web PWA + Android + iOS)
packages/hexwild_rules/  Board generation, protocol, shared types
.github/workflows/       Deploy web to GitHub Pages on push to main
```

## Why Flutter

Hex board rendering, one codebase for PWA + native, and a clear path to Multipeer/Nearby on mobile. See earlier project notes for online phase 2.
