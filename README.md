# browser-game-to-portal

> A Claude Code skill that takes a small browser game from "I have an idea" to live on CrazyGames, Poki, itch.io and Newgrounds.

## Overview

You describe your game, or say you don't have one yet. Claude helps you pin it down to one rule, builds it in small approved steps, checks that real players actually finish a round, and packages it for game portals. You don't need to code. Your job is to play each version and say what feels off.

Based on [@0xbobaaa's guide](https://x.com/0xbobaaa/status/2112514472078115173) to building *Skyhold* with Claude Opus 5.5: 22 build steps, about $164, 9 days from an empty folder to passing CrazyGames' QA on the first try.

## How it works

1. **Find the rule.** One sentence a stranger gets in 2 seconds. No idea yet? Claude asks four questions and pitches five options. You pick.
2. **One-page plan.** The loop, how you win, how you lose, and controls on desktop and phone.
3. **Pick the look.** Choose from 7 code-only 3D styles (low-poly, toon, voxel, clay, isometric, neon, pixel) and a free font pair. It's saved as `STYLE.md`, so every pass keeps the same look.
4. **Small passes.** Each Claude run builds one feature and gets a **keep list** of what's already approved, so new work doesn't break old work. You play after every pass.
5. **Fix the first minute.** Track visited → opened → started → finished. No new features until people finish a round.
6. **Home page + self-recording trailer.** Your own site with PLAY on top, then the rules, an interactive rule demo, and a build log. A `?capture` mode plays the game on autopilot and saves frames for clips and covers.
7. **One adapter, one zip per portal.** Each portal's SDK (the library it requires for saves, ads and mute) sits behind one small layer, so the game code never changes.
8. **Fix the worst number.** After launch: impressions, click rate, play time, next-day return.

You can enter at any step. Claude works out where your project is.

## Install

Requires [Claude Code](https://claude.com/claude-code). The pass runner also needs `bash` and `python3`.

```bash
git clone https://github.com/tmoody1973/browser-game-to-portal ~/.claude/skills/browser-game-to-portal
```

Then, in Claude Code, say something like:

- "Brainstorm a browser game I could ship to CrazyGames"
- "Write a pass brief to add a scoreboard to my game"
- "My game's live but nobody finishes a run. What do I fix?"

## Running a pass headless

```bash
# From your game's folder. Write a five-part brief (see references/briefs.md) first.
~/.claude/skills/browser-game-to-portal/scripts/run-pass.sh brief.txt scoreboard

# Optional: pick the model and cap the spend
MODEL=sonnet MAX_BUDGET_USD=5 ~/.claude/skills/browser-game-to-portal/scripts/run-pass.sh brief.txt scoreboard
```

Each run saves its raw output to `runs/` and adds a line to `passes.jsonl` with the cost, minutes, and a running project total.

**Cost warning:** each pass is a real Claude run billed to your account. The guide's passes cost $1.01–$12.94 each on Opus. Use `MAX_BUDGET_USD` to cap a run.

## Structure

```
browser-game-to-portal/
├── SKILL.md              # Stage router, brainstorm, pass loop, defaults, guardrails
├── references/
│   ├── briefs.md         # Five-part brief template + the guide's prompts
│   ├── style.md          # 7 code-only 3D styles, fonts, per-portal cover rules
│   ├── landing.md        # The game's home page (modelled on skyhold.lol)
│   ├── portals.md        # SDK adapter, size budgets, QA gate, launch paths, video specs
│   └── funnel.md         # First-minute funnel and post-launch numbers
└── scripts/
    └── run-pass.sh       # Run one brief headless, log its cost
```

## Caveats

- Portal requirements are as described in the guide (late 2026). Check each portal's current developer docs before submitting.
- Built for small games you can understand at a glance, not big multi-system games.

## Credits & license

The method, the Skyhold numbers, and the prompts marked **verbatim** in `references/briefs.md` come from [@0xbobaaa's article](https://x.com/0xbobaaa/status/2112514472078115173). They're quoted with credit and remain the author's. Everything else is released under the [MIT License](LICENSE).
