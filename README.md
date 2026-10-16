# Hexwild

Original hex territory board game (Catan-style structure, own names and art). **Nearby-first** MVP on **Flutter**, with online play planned for phase 2.

## Why Flutter (not React Native)

| Factor | Flutter | React Native |
|--------|---------|--------------|
| Hex board rendering | CustomPainter + Skia, smooth pinch/zoom | RN Skia works; more bridge friction |
| Touch/gesture game UI | First-class, consistent iOS/Android | Good with extra libraries |
| Nearby native APIs | Platform channels / existing plugins | Expo needs custom native modules |
| Shared rules with future Node server | Dart package now; port or codegen later | Same TS package as backend |

For a **gesture-heavy board game + Multipeer/Nearby**, Flutter is the better default.

## Renaming (structure unchanged)

| Classic | Hexwild |
|---------|---------|
| Settlement / City | Outpost / Stronghold |
| Road | Trail |
| Robber | Raider |
| Development cards | Fortune cards |
| Longest Road | Great Route |
| Largest Army | Warlord's Banner |
| Wood, Brick, Sheep, Wheat, Ore | Timber, Clay, Wool, Grain, Iron |
| Desert | Badlands |

## Repo layout

```
apps/mobile/           Flutter app (iOS + Android)
packages/hexwild_rules/  Board generation, protocol, shared types
```

## Nearby MVP (current)

1. **Host** opens a LAN WebSocket (port `8765`), shows room code + local IP.
2. **Join** with host IP + display name (same Wi‑Fi).
3. Host starts at **3–4 explorers** → random 19-hex board → table view with pinch-zoom map.

Next slices: setup placement, roll/trade/build state machine, BLE/mDNS discovery, then online authoritative server.

## Develop

Requires Flutter 3.24+ (`flutter` on PATH).

```bash
cd apps/mobile
flutter pub get
flutter run
cd ../../packages/hexwild_rules && dart test
```

## Phase roadmap

1. **Now** — LAN lobby + board + rules package skeleton  
2. Full turn loop (host-authoritative)  
3. iOS Multipeer + Android Nearby + mDNS  
4. Online server + accounts + reconnect  
