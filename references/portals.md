# Portals

Requirements below are per the guide (late 2026). **Re-check each portal's current developer docs before submitting.** Portals change rules, and the guide is one person's run.

## The adapter

Every portal wants its own SDK for the same handful of moments: loading start/stop, gameplay start/stop, ads between runs, mute. Put them all behind one small module so the game only ever calls e.g. `platform.gameplayStart()` and never knows which portal it's on. itch.io = no SDK (the adapter's no-op case).

Portal mode turns off: sign-in, leaderboard, calls to your own API. Ads go between runs, at most every 3 minutes. Mute follows the portal's setting.

## The build

One folder and one zip per portal: `index.html` in the root, relative paths only, no calls to your own server. (Prompt 3 in briefs.md.)

## CrazyGames QA gate (Basic Launch)

Their test page runs your build and lights up each SDK call it sees.

- [ ] Initial download under 50 MB
- [ ] First gameplay start fires. **Play a round in their test window, or it stays red.**
- [ ] No external ads, no external login
- [ ] Runs on all their domains, desktop and phone
- [ ] Progress saved through the SDK Data Module, not plain `localStorage` (derived SDK-save brief)
- [ ] Upload the **unzipped files**, not the zip

## Launch paths

| Portal | What happens | Notes |
|---|---|---|
| itch.io | Live in ~10 min, no review | Embed 960×720, turn on "mobile friendly" |
| Newgrounds | Live at once, then 3 days of player votes | Good scores keep it, bad ones get it removed |
| CrazyGames | SDK QA → Basic Launch in the "New" carousel for a few weeks | Good numbers unlock full launch + ad revenue |
| Poki | Apply with a playable link first | They invite you to upload only if they like it |

Suggested order: itch.io (instant, for a public link) → CrazyGames → Newgrounds → Poki application with the itch link.

## Assets every portal asks for

- Cover: 16:9, often portrait and square too
- Gameplay clip: 15–20 s

Both come from `?capture` mode. Re-record whenever the game changes.
