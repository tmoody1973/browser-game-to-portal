# Sound

Like the look, sound is decided once and written into `STYLE.md` (a `Sound:` line), then built as **one pass** after the first minute works. The guide had Opus write "the music" too, so audio follows the same rule as art: made in code, bundled, no outside requests.

Facts checked Oct 2026. Links inline.

## Sound serves the rule

Pick sounds in this order, and stop when the game feels alive:

1. **The warning:** the sound right *before* failure, rising as danger nears. This is the one that teaches the rule. (Head Room: a fizz that climbs as the foam nears the rim.)
2. **Input feedback:** a continuous sound that follows the player's input. (Head Room: the pour gets louder and brighter the further you pull.)
3. **Success and failure:** one short sound each, clearly different. A strike is lower and duller than a serve.
4. **Round end:** a win jingle and a lose sting.
5. **UI:** a soft click. *Optional:* music, quiet and off-able.

Never put information **only** in sound. Every cue needs a visual twin, because plenty of portal players play muted.

## Three ways to make it

| Option | What | Cost | When |
|---|---|---|---|
| **A. Synthesize in code** (default) | Web Audio API: oscillators, a noise buffer, `BiquadFilterNode`, gain envelopes | 0 files, ~150 lines | Always fits the guide's "no asset files" stack |
| **B. ZzFX** | [ZzFX](https://github.com/KilledByAPixel/ZzFX): "a tiny sound generator", **MIT**. Each sound is one parameter array, e.g. `zzfx(...[,,925,.04,.3,.6,1,.3,,6.27,-184,.09,.17]) // Game Over` | One tiny vendored file | Fast retro/arcade sounds. Vendor it into `lib/`, no CDN |
| **C. Generated or recorded files** | AI-generated SFX (e.g. ElevenLabs; the `threejs-audio-generator` skill if installed), or libraries whose licence you've confirmed | KBs to MBs per sound | When realism matters. Bundle everything (Poki blocks external audio), mind Poki's < 5 MB guidance, credit licences in the footer |

**Option A recipes** (one shared `AudioContext`, everything into a master `GainNode`):
- **Noise-based** (pour, fizz, wind, splash): loop a 1–2 s buffer of random samples through a `BiquadFilterNode`. Drive `frequency` and `gain` from game state every frame with `setTargetAtTime` (no clicks).
- **Tonal** (ding, coin, jingle): `OscillatorNode` (sine/triangle) with a fast attack and short exponential decay. Stack 2–3 partials for a bell or coin.
- **Thud** (strike, impact): a sine sweeping down (e.g. 180 → 60 Hz over 0.15 s) plus a short burst of low-passed noise.
- **Stings:** 3–4 notes from one scale, about 0.12 s apart. Up for a win, down for a loss.

## Rules that bite

- **Unlock on a gesture.** Create or `resume()` the `AudioContext` inside the Start button's click handler. Audio contexts can only play after the page has had user activation ([MDN autoplay](https://developer.mozilla.org/en-US/docs/Web/Media/Guides/Autoplay)).
- **iOS interrupts audio** when the game goes to the background. Resume it on `visibilitychange`. CrazyGames documents this exact problem ([technical](https://docs.crazygames.com/requirements/technical/)).
- **Mute during ads.** CrazyGames: "mute the audio and pause the game when the ad starts … unmute … when the ad finishes/fails" ([video ads](https://docs.crazygames.com/sdk/video-ads/)). Poki: "automatically mute game audio during advertisement playback" ([quality](https://developers.poki.com/guide/requirements-quality)). Route this through the portal adapter.
- **Mute toggle** in the HUD (and the `M` key). On a portal, mute follows the portal's setting (Prompt 3). On your own site, remember the choice.
- **Capture mode is silent.** CrazyGames preview videos must have no sound anyway.
- **Quiet by default.** Master gain around 0.4. Keep the continuous sounds lowest and the warning loudest.

## Derived brief: sound pass

```
Read first: the main loop, the module that holds the core rule's state, the HUD, STYLE.md. Skip lib/.
Do exactly this: add sound in one new module (src/audio.js), synthesized with the Web Audio API, no audio files: [the warning], [input feedback], [success], [failure], [round win], [round lose], [UI click]. One AudioContext created or resumed on the start click, resumed on visibilitychange. A mute button in the HUD and the M key, remembered across reloads. Master gain about 0.4. Follow the Sound line in STYLE.md.
Keep working exactly as they are: [KEEP.md]. Do not change any gameplay numbers. Follow STYLE.md exactly.
Done means: [the warning] is audible before every failure and gets louder as danger nears; each listed event has its own sound; mute silences everything and stays muted after reload.
Do not open a browser. Just write the files. No runtime errors.
```
