# Briefs

Prompts 1–3 and the run command are **verbatim from the guide**. Fill the `[brackets]`, change nothing else unless the user asks. Prompts marked *derived* are built from the guide's prose (it describes the pass but doesn't print the prompt). Label them as derived when you use them.

## The five-part brief (every pass)

1. **Read these files first** (and skip the big library files).
2. **Do exactly this one thing.**
3. **Keep these things working exactly as they are.** ← the line people skip
4. **Done means** [something I can check by playing].
5. **Do not open a browser. No runtime errors.**

Template:

```
Read first: [files touched by this system]. Skip [three.module.js / vendor/ / other big libs].
Do exactly this: [one system, one sentence].
Keep working exactly as they are: [paste KEEP.md]
Done means: [a check a human can do by playing, e.g. "I drop 3 houses and the island tilts toward the heavier side"].
Do not open a browser. Just write the files. No runtime errors.
```

Writing a good "done means": it's observable in play, binary, and about one system. Bad: "physics feels good." Good: "past 15° the edge houses start to slide."

## Run command (verbatim)

```
claude -p --model opus --output-format json --permission-mode acceptEdits --allowedTools "Read,Write,Edit,Glob,Grep" < brief.txt > run.json
```

`scripts/run-pass.sh` wraps this and appends `{pass, cost, minutes, turns, is_error}` to `passes.jsonl`. JSON fields: `total_cost_usd`, `duration_ms`, `num_turns`, `is_error`, `result`, `session_id`.

## Prompt 1. The day-one brief (verbatim)

```
Build a small but polished 3D browser game in this folder, entry point index.html.
The rule: [your one-line rule].
The loop: [what the player does every 5 seconds].
Win: [the exact condition]. Lose: [the exact condition].
Tech: three.js loaded locally through an importmap, no other scripts, every model and texture built from code.
Done means: I can open index.html, play one full round with the mouse, win or lose, and restart.
Do not open a browser. Just write the files. No runtime errors.
```

Guide result: 46 minutes, a playable island, "ugly in places, but playable, and that's the only goal of day one." For a 2D game, swap the Tech line. Keep "local, no other scripts, built from code."

## Prompt 2. Fix the funnel (verbatim)

```
Real numbers from today: [visitors] -> [opened] -> [started] -> [finished].
1. The game must be one tap away on the first screen of a phone.
2. The first run ever must reach a satisfying ending inside 90 seconds, with a clear win screen and a reward. No sign-in or forms before it ends.
3. Send these events to my stats endpoint: game loaded, first move, run end with reason (win / lose / quit) and seconds.
Keep every existing mode working exactly as it is.
```

Guide result: the first island became "keep 6 homes standing" (most people win in under 30 s). Then 62 islands saved in four days, up from 0 finished runs.

## Prompt 3. Portal mode (verbatim)

```
Add a portal mode behind one adapter (CrazyGames SDK v3, GameDistribution, Poki, itch.io = no SDK). The game calls only the adapter. In portal mode: no sign-in, no leaderboard, no calls to my API, an ad between runs at most every 3 minutes, mute follows the portal's setting. Write a node build script that outputs one zip per portal with index.html in the root.
```

## Derived: SDK save (guide: one pass, $1.01)

```
Read first: the portal adapter and every file that reads or writes saved progress.
Do exactly this: in CrazyGames portal mode, read every save from the CrazyGames SDK Data Module on boot, then mirror every later write into it. Outside portal mode, saving stays as it is.
Keep working exactly as they are: [KEEP.md]
Done means: in the CrazyGames build, progress survives a reload with localStorage cleared.
Do not open a browser. Just write the files. No runtime errors.
```

## Derived: capture mode

```
Read first: the main loop, the renderer setup, the input handling.
Do exactly this: add a ?capture mode: a fixed-size canvas ([1920x1080]), a deterministic window.render(t) that draws the frame at time t with no real-time clock or unseeded randomness, and a scripted demo that plays the real game for [20] seconds. Then write a headless-browser script that steps t frame by frame at [30] fps and saves the frames.
Keep working exactly as they are: [KEEP.md]. Normal mode must be untouched when ?capture is absent.
Done means: running the script twice produces identical frames.
Do not open a browser. Just write the files. No runtime errors.
```

## Derived: cover fix (when click rate is worst)

```
Read first: the capture mode and the mascot module.
Do exactly this: add a capture scene for the portal cover: [bigger mascots, the core mechanic visibly happening, e.g. an island clearly tipping]. Export 16:9, portrait, and square stills.
Keep working exactly as they are: [KEEP.md]
Done means: a stranger looking at the 16:9 still for 2 seconds can say what the game is.
Do not open a browser. Just write the files. No runtime errors.
```
