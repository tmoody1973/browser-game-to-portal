# The game's home page (own domain)

The guide: "Put it on your own domain from day one so every post links to the same address." This page lives at that address. Portal builds **don't** include it, since portals have their own page.

Worked example: [skyhold.lol](https://skyhold.lol), read Oct 2026. Section order below is Skyhold's.

## One rule above all

**PLAY is one tap away on the first screen of a phone** (Prompt 2, rule 1). Everything "about" sits below the fold, behind a `what is it? ↓` link. Never between the visitor and the game.

## Sections, in order

1. **Poster** (first screen): title · the rule phrased as a goal ("Keep the floating island level.") · PLAY · a reassurance line ("free · no sign-up · first island takes a minute") · `what is it? ↓` to `#more`.
2. **Pitch**: the story in one sentence ("The sky islands are falling. Houses arrive by balloon, one at a time, and you drop each one where it keeps the island level.") · a facts strip (run length · input · saves itself) · the demo video from `?capture` (`muted loop playsinline preload="none"`, poster image, `aria-label`).
3. **Live hooks** *(only if the game has them)*: daily challenge, shared world, leaderboard, with live numbers.
4. **The rule** (`#rule`): the heading **is** the one-line rule ("The island has a centre of mass"). One paragraph. **One toy** that lets a visitor feel the rule without playing (Skyhold: a slider loads the east side, a gauge tilts, labels show "15° · the low rim starts sliding", "19° for 3 s and the island flips").
5. **How a run works** (`#how`): what the player controls and what they don't ("You do not choose what to build"). Then a glossary of pieces or items: **name · one stat · one-line effect** ("Tower · weight 4 · big score, big lean").
6. **Modes / chapters**: name + one-line goal each ("Meadowfall: Keep 12 homes standing until sunset.").
7. **Build log** (`#log`): one entry per day: what changed + the numbers (minutes, $), taken from `passes.jsonl`. The last entry points forward ("Day 4 · next: your ideas from the replies"). This doubles as post material.
8. **Footer**: credits · engine licence ("three.js r160 (MIT)") · font licences if self-hosted.

## Rules on the page come from the game's own config

Weights, thresholds, timers and piece lists must be **imported from the same constants module the game uses**, not retyped. Otherwise the first balance pass makes the page lie. The rule toy should call the game's real tilt or score function, at a small size.

## `<head>`

- `<meta name="description">`: what it is + the twist ("A cozy city builder on a floating island. Build too much on one side and it tips.")
- `og:title`, plus `og:description` as the **story hook**, different from the description ("The sky islands are falling. Keep yours level.")
- `og:image`: 1200×630 still from `?capture`, absolute URL
- `twitter:card` = `summary_large_image`, a favicon

## Copy style (as seen on Skyhold)

Headings are claims, not labels ("One island. Everyone. Today."). Small labels are lowercase and dot-separated ("free · no sign-up"). Numbers are always specific (15°, 3–6 minutes, $12.94). No marketing adjectives.

## Derived brief: home page

```
Read first: index.html, the game's constants/config module, passes.jsonl, STYLE.md.
Do exactly this: build the home page for the game's own domain per references/landing.md: poster with PLAY first, then #more with pitch + demo video, the rule section with one interactive toy that calls the real game function, how-a-run-works glossary generated from the config module, modes, build log from passes.jsonl, footer with licences, and the <head> meta + og tags.
Keep working exactly as they are: [KEEP.md]. The game itself and every portal build are untouched; the home page is not included in portal zips.
Done means: on a phone-sized screen PLAY is visible without scrolling and starts a run in one tap; changing a weight in the config changes the number on the page.
Do not open a browser. Just write the files. No runtime errors.
```
