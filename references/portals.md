# Portals

Checked Oct 2026 against each portal's docs (links inline). **Re-check before submitting.** Portals change their rules. Newgrounds and GameDistribution rules couldn't be verified (docs blocked or missing).

## The adapter

Every portal wants its own SDK for the same handful of moments: loading start/stop, gameplay start/stop, ads between runs, mute. Put them all behind one small module so the game only ever calls e.g. `platform.gameplayStart()` and never knows which portal it's on. itch.io = no SDK (the adapter's no-op case).

Portal mode turns off: sign-in, leaderboard, calls to your own API. Ads go between runs, at most every 3 minutes. Mute follows the portal's setting.

## The build

One folder and one zip per portal: `index.html` in the root, **relative paths only**, no calls to your own server (Prompt 3 in briefs.md).

**Everything bundled: fonts, libraries, audio.** Poki blocks all external requests by default: "No runtime requests to Google Fonts, externally hosted images or audio, or code libraries on external CDNs like jsDelivr" ([policy](https://developers.poki.com/guide/external-resources-policy)). Exceptions (multiplayer, leaderboards, some analytics) need per-game approval. itch.io: absolute paths 403, and file names are case-sensitive ([itch docs](https://itch.io/docs/creators/html5)).

## Size budgets

| Portal | Limit |
|---|---|
| CrazyGames | Initial download ≤ 50 MB, ≤ 20 MB for the mobile homepage, ≤ 250 MB / 1,500 files total, time to gameplay ≤ 20 s ([technical](https://docs.crazygames.com/requirements/technical/)) |
| Poki | Guidance: initial < 5 MB, < 8 MB total ([web engine](https://developers.poki.com/guide/web-engine)). Players leave if loading takes over 10 s |
| itch.io | ≤ 500 MB extracted, ≤ 200 MB per file, paths ≤ 240 characters |

The guide's code-drawn stack (Skyhold: 1.5 MB) clears all of them.

## CrazyGames QA gate (Basic Launch)

Their test page runs your build and lights up each SDK call it sees.

- [ ] Initial download within budget (above)
- [ ] First gameplay start fires. **Play a round in their test window, or it stays red.**
- [ ] No external ads, no external login, no cross-promotion
- [ ] Runs on all their domains, desktop and phone
- [ ] Text legible at an 800×450 iframe with devicePixelRatio 1. English included
- [ ] Progress saved through the SDK Data Module, not plain `localStorage` (derived SDK-save brief)
- [ ] `user-select: none` on body for mobile
- [ ] Upload the **unzipped files**, not the zip

## Launch paths

| Portal | What happens | Notes |
|---|---|---|
| itch.io | Live in ~10 min, no review | Embed 960×720, turn on "mobile friendly" |
| Newgrounds | Live at once, then 3 days of player votes | Good scores keep it, bad ones get it removed |
| CrazyGames | SDK QA → Basic Launch in the "New" carousel for a few weeks | Good numbers unlock full launch + ad revenue |
| Poki | Apply with a playable link first | They invite you to upload only if they like it. Static **and** animated thumbnail needed for global release |

Suggested order: itch.io (instant, for a public link) → CrazyGames → Newgrounds → Poki application with the itch link.

## Covers & video

Cover type rules **conflict**: CrazyGames wants the title on the cover, Poki wants no text. Full table in [style.md](style.md#covers-type-rules-differ-per-portal).

CrazyGames preview video ([covers page](https://docs.crazygames.com/requirements/game-covers/)): 15–20 s, ≤ 50 MB, 1080p **landscape 16:9 and portrait 2:3**. No sound, no black bars, no default mouse cursor, no "Play Now" text, no fast-forwarding. **The first frame is the static cover.**

All of it comes from `?capture` mode. Script a portrait camera as well as landscape. Re-record whenever the game changes.
