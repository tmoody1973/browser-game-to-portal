---
name: browser-game-to-portal
description: Takes a small browser game from an empty folder (or any stage after) to live on web game portals (CrazyGames, Poki, itch.io, Newgrounds) using a one-line rule, a one-page game doc, short single-system AI passes with a "keep" list, a self-recording trailer mode, a first-minute funnel, a portal SDK adapter, and post-launch numbers. Use when the user wants to brainstorm a game idea, or make, scope, brief, ship, or grow a browser/HTML5/three.js game, mentions game portals or their SDK/QA, asks how to brief Claude for a game feature, or a game has features but nobody finishes a run.
---

# Browser Game → Portal

Source: @0xbobaaa's "How to Build and Ship Your Own Browser Game with Claude Opus 5.5" (Skyhold: 22 passes, ~$164, 9 days, CrazyGames SDK QA 7/7 first try). The craft lives in [references/briefs.md](references/briefs.md). Use those prompts as written; don't paraphrase them.

**The rule that saved the project: fix the first minute before you build the fifth island.**

## Find the stage, start there

Ask what exists, then jump in. Don't restart a project that's already moving.

| They have… | Do | Read |
|---|---|---|
| Nothing, a vibe, or "make me a game" | **Find the rule**: a short brainstorm that ends in one sentence | below |
| An idea but no rule | Same brainstorm, starting from step 2 with their idea as the seed | below |
| A rule | Write the **one-page doc**, then run Prompt 1 (day-one brief). Goal: playable, ugly is fine. | briefs.md |
| A playable core | **Passes**: one system per run, five-part brief. | briefs.md |
| Features, but no traffic data | **Measure first.** Add funnel events, run Prompt 2. Freeze new features. | funnel.md |
| A first minute that works | **Host** on own domain, add `?capture` trailer mode | below, briefs.md |
| Ready to publish | **Portal adapter + one zip per portal** (Prompt 3), pass the QA gate | portals.md |
| Live on a portal | **Four numbers**. Fix the worst one, one pass at a time | funnel.md |

## Find the rule (brainstorm that converges)

The output is one sentence a stranger gets in 2 s, before the first tap (Skyhold: "the island has a centre of mass").

1. **Ask** (one AskUserQuestion, skip anything they've already said): the feeling (cozy, tense, chaotic, clever), the input (one tap, drag, aim, two keys), the session (30 s bursts or 5 min runs), one game they love.
2. **Generate 5 rules.** Each one names a single physical or systemic truth, plus the 5-second loop it implies. Spread them across feelings. Don't write five versions of one idea.
3. **Filter** each candidate:
   - 2-second test: one screenshot explains it.
   - "And" test: needs "and" twice → it's two games.
   - Rule is the tutorial: losing teaches it, no menu text needed.
   - 90-second ending: a first run can end satisfyingly in under 90 s.
   - Drawable in code: no image files needed (if on the default stack).
   - Phone test: playable with one thumb.
4. **Show the survivors** in a table (rule · loop · win · lose · weakest test). **The user picks. Don't pick for them.** Optional deeper check on the pick: `game-design`.
5. The picked rule goes into the one-page doc.

## The one-page doc (before any code)

Rule · loop (what the player does every 5 s) · win · lose · camera · controls on desktop **and** phone · what "done for today" means. Fill the blanks with the user. Don't invent their game.

## The pass loop

1. Pick ONE system. Write a brief using the five-part template in briefs.md.
2. Run it: `scripts/run-pass.sh brief.txt` (headless `claude -p`, logs cost to `passes.jsonl`), or hand the same brief to a subagent or do it in-session. **The brief is the method. The runner is interchangeable.**
3. The human playtests. Accepted behaviour joins the project's **keep list** (`KEEP.md`), which goes into every later brief.
4. Next pass. Each one gets one finish line you can check by playing.

The guide's range: $1.01 (SDK save) to $12.94 (arcade loop) per pass, and 46 min for the day-one pass. The cost per feature comes back in the JSON, so the ledger shows what each feature cost.

## Defaults (each one is a knob, not a law)

| Knob | Guide default | Flex |
|---|---|---|
| Engine | three.js loaded locally via importmap, no other scripts | Canvas 2D, Phaser, PixiJS. Keep "one engine, no build step" |
| Art | All drawn in code: low-poly meshes, SVG mascots in one module, no image files | Allowed if the user insists. You give up the tiny build (Skyhold: 1.5 MB) and the "no licences to check" benefit |
| Model | `--model opus` | Any. Keep the tool allowlist tight |
| Host | One small Node process (Skyhold: 20 MB RAM, ~$0.19/mo), own domain from day one | Any static host + tiny endpoint |
| Portals | CrazyGames, Poki, GameDistribution, itch.io, Newgrounds | Any subset. Adapter makes adding one cheap |

## Trailer: let the game record itself

Add `?capture`: fixed-size canvas, deterministic `window.render(t)`, and a scripted demo that plays the real game. Record frame by frame with a headless browser (a committed Playwright script works well, since this belongs in the repo). Re-record whenever the game changes. Feeds the portals' 15–20 s clip and their covers (16:9, plus portrait/square).

## Guardrails: six mistakes that waste a weekend

1. One prompt for the whole game → demo falls apart on feature two.
2. No keep list → every pass quietly breaks something already liked.
3. Building the fifth island before the first minute works.
4. Sign-in before the first round ends (guide: 9 players → 0 sign-ins).
5. Saving to `localStorage` on a portal that requires its SDK → instant QA fail.
6. Judging by build cost. $164 is nothing. Retention is the whole story.

## Who does what

AI: code, art, mascots, music. Engine: the world. Headless browser: trailers. Portals: players and honest feedback. **Human: playtest, read the numbers, say what feels off.** Never mark a pass "done" without the human's play-check, or a scripted playthrough as a stand-in that you label as one.

## Hand-offs (if these skills are installed; don't duplicate them)

- Visual polish, AAA lighting, premium bar → `threejs-game-director`
- Gameplay QA matrix, regressions → `test-playable-web-games`
- Deploy proof and rollback for the own-domain host → `ship-web-games`
- Mobile touch and perf for three.js → `build-mobile-threejs-games`
