# Funnel & numbers

## Before launch: the first-minute funnel

`visitors → opened the game → started a run → finished a run`

Guide, day 4, with five story islands, a daily island, and a leaderboard: **51 → 13 → 6 → 0.** Nobody needed a fifth island. They needed the first minute to work.

Minimum events (Prompt 2 adds them): `game_loaded`, `first_move`, `run_end {reason: win|lose|quit, seconds}`. Visitors come from the host's request log.

Reading it:
- visitors → opened is low: the game isn't one tap away on a phone's first screen.
- opened → started is low: the rule isn't obvious, or controls fail on touch.
- started → finished is low: the first run is too long or too hard. Target a satisfying ending inside 90 s (Skyhold's fix: "keep 6 homes standing", won in under 30 s).
- Anything before the first ending (sign-in, forms) is a wall. Remove it.

**Freeze features until a run gets finished.** Then re-measure after each pass.

## After launch: the four numbers that decide if it lives

1. **Impressions**: how many see the cover
2. **Click rate**: how many click it
3. **Play time**: how long they play
4. **Day-1 return**: whether they come back the next day

Guide's first CrazyGames day: 141 impressions, 1.4% clicked (bottom 20%), ~3 min play, 0 crashes, 2.3 s load. Worst number = click rate → the first fix was the **cover, not the game** (bigger mascots, an island clearly tipping).

**Fix the number that's worst, one pass at a time.** Build cost stops mattering once you're live.
