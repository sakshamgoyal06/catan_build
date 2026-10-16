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

1. Open **[Settings → Pages](https://github.com/sakshamgoyal06/catan_build/settings/pages)** for this repo.
2. Under **Build and deployment → Source**, choose **GitHub Actions** (not “Deploy from a branch”).  
   If Pages was never enabled, pick **GitHub Actions** once — this creates the Pages site.
3. Push to **`main`** or re-run the workflow: **Actions → Deploy web PWA → Run workflow**.

After a green deploy, the site is at **https://sakshamgoyal06.github.io/catan_build/**

### Deploy failed with `HttpError: Not Found` / “Ensure GitHub Pages has been enabled”

The Flutter **build** succeeded; **deploy** failed because Pages is not turned on yet. Do step 1–2 above, then **Re-run all jobs** on the failed workflow run.

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
