# Style & type

Pick the look **once**, write it to `STYLE.md` in the game folder, and pass it into every brief next to `KEEP.md`. Without it, each pass invents its own palette and the game drifts.

Facts checked Oct 2026 against three.js r186 source/docs, portal docs, and google/fonts. Marked *(unverified)* where they weren't.

## How to pick

1. **The look serves the rule.** Pick the style that makes the rule readable. Skyhold's rule is weight → tilt, so it needs clear silhouettes and an obvious horizon line.
2. **Thumbnail test.** At cover size (~200 px wide), can you see the rule happening? The guide's first fix after launch was the cover: "bigger mascots, an island that's clearly tipping."
3. **Phone budget.** Portal players are often on mid-range phones. Prefer *cheap* styles, or ship the cheap fallback on mobile.
4. Offer the user **2–3 styles** from the menu below, each with its reference games. **They pick.**

## STYLE.md template

```
Look: [style] because [how it makes the rule readable]
Palette: bg #… · ground #… · hero #… · accent #… · danger #…
Materials: […]   Light & fog: […]   Camera: […]
Post-processing: none | […] (phone fallback: […])
Type: display [font] · UI [font] · numbers [font or tabular-nums], self-hosted woff2 in fonts/, OFL
Never: [what breaks the look, e.g. "no pure black", "no gradients on UI"]
```

## The menu (all code-only, no image files)

| # | Style | Feels | References | Phone cost |
|---|---|---|---|---|
| 1 | Low-poly flat pastel | cozy, calm | Skyhold, [Townscaper](https://www.townscapergame.com/) | cheap |
| 2 | Toon / cel + outlines | cartoon, bold | three.js `webgl_materials_toon`, Wind Waker | medium (cheap with hull outlines) |
| 3 | Voxel / blocky | toy-like, arcade | [Crossy Road](https://www.crossyroad.com/) | cheap |
| 4 | Soft clay / diorama | tactile, warm | Lego Builder's Journey *(unverified)* | medium |
| 5 | Minimal isometric | clever, puzzle | [Monument Valley](https://www.monumentvalleygame.com/) | cheap |
| 6 | Neon / synthwave | fast, intense | `webgl_postprocessing_unreal_bloom` | expensive (cheap fake available) |
| 7 | Retro PS1 / pixel | eerie, nostalgic | `webgl_postprocessing_pixel` | cheap (low-res variant) |

Examples live at `https://threejs.org/examples/#<name>`.

**1. Low-poly flat pastel.** `MeshLambertMaterial({ color, flatShading: true })`. `HemisphereLight` (warm sky, cool ground) + one `DirectionalLight`. `scene.fog = new Fog(bg, near, far)` matching the background. Perspective camera, 35–45° FOV, tilted down. No post-processing. 5–6 hues, with lightness jitter per object via `color.offsetHSL(0, 0, (Math.random() - .5) * .05)`. Fake blob shadows (dark transparent circles) instead of shadow maps. *Pitfall:* shared smooth normals erase the facets. Use `geometry.toNonIndexed()` before computing normals.

**2. Toon / cel.** `MeshToonMaterial` + a gradient ramp built in code:
```js
const ramp = new THREE.DataTexture(new Uint8Array([90, 170, 255]), 3, 1, THREE.RedFormat);
ramp.minFilter = ramp.magFilter = THREE.NearestFilter; // required by the docs, or steps blur
ramp.needsUpdate = true;
```
One `DirectionalLight` + weak ambient. Outlines, cheapest first: **inverted hull** on hero objects (a copy with `MeshBasicMaterial({ color: 0x000000, side: THREE.BackSide })`, scaled ~1.04×). Then `OutlineEffect(renderer, { defaultThickness: 0.003 })` for everything (≈2× draw calls). `OutlinePass` is the heaviest *(details unverified)*. Avoid it on phones. *Pitfall:* the hull gaps at hard corners on flat-shaded meshes. Use smooth normals on outlined objects.

**3. Voxel.** `BoxGeometry` through `InstancedMesh` + `setColorAt` (one draw call per block type; set `instanceColor.needsUpdate = true`). Lambert, flat colours with 3 shades per hue (top / side / dark). Follow-camera at a fixed isometric-ish offset. Fog hides pop-in. *Pitfall:* the instance count is fixed up front, so allocate the max.

**4. Soft clay.** `RoundedBoxGeometry(w, h, d, 3, 0.15)`, spheres, capsules. `MeshStandardMaterial({ roughness: .9, metalness: 0 })`. Strong `HemisphereLight` + one soft directional. One tight-frustum `PCFSoftShadowMap` or blob shadows. Optional SAO/GTAO for contact darkening, which is expensive: skip it on mobile. *Pitfall:* the triangle count balloons. Keep segments at 3–4 and instance the repeats.

**5. Minimal isometric.** `OrthographicCamera` at `(d, d, d)` looking at the origin. Recompute left/right/top/bottom from the aspect on resize. `MeshBasicMaterial`/Lambert with 3 tonal values per hue painted per face instead of real lighting. CSS gradient background. No fog, no post. *Pitfall:* z-fighting on near-coplanar faces. Offset them and keep `near`/`far` tight.

**6. Neon.** Near-black background (`#05000f`). `emissive` + `emissiveIntensity`. `LineSegments` grid floor. `EffectComposer`: `RenderPass` → `UnrealBloomPass(new Vector2(w, h), 1.5, 0.4, 0.85)` → `OutputPass`, with `renderer.toneMapping = ACESFilmicToneMapping` (as in the example). **Phone fallback:** no bloom. Add a larger translucent copy of each neon mesh with `blending: AdditiveBlending, depthWrite: false`. *Pitfall:* everything bright blooms, including UI. Raise the threshold or use the selective-bloom example.

**7. Retro pixel.** Cheapest: `renderer.setPixelRatio(0.25–0.5)` + CSS `canvas { image-rendering: pixelated }`. Fancier: `RenderPixelatedPass(6, scene, camera)` → `OutputPass` (adds depth/normal passes: medium cost). Code-drawn `CanvasTexture`s with `NearestFilter`. Short, hazy fog. PS1 vertex snapping needs a custom shader: round clip-space xy to a grid *(sketch, untested; no ready-made addon)*. *Pitfall:* UI drawn into the low-res canvas turns to mush, so keep the HUD in DOM.

## Type

**Self-host every font. No Google Fonts CDN in any build.** Poki: "No runtime requests to Google Fonts, externally hosted images or audio, or code libraries on external CDNs" ([policy](https://developers.poki.com/guide/external-resources-policy)). CrazyGames requires relative paths ([technical](https://docs.crazygames.com/requirements/technical/)). Self-hosting also avoids the Munich court's 2022 ruling that sending visitor IPs to Google Fonts without consent breaks GDPR ([The Register](https://www.theregister.com/offbeat/2022/01/31/google-fonts-lands-website-privacy-fine-by-german-court/1494285)). Download woff2 from [google-webfonts-helper](https://gwfh.mranftl.com), and subset to the glyphs you use with [`pyftsubset`](https://fonttools.readthedocs.io/en/latest/subset/) from fonttools. *(Skyhold's own home page loads from the CDN. That's fine on your own site; it isn't fine in a portal zip.)*

**Rules**
- Two families: **display** (title, big numbers) + **UI** (everything else). An optional third is mono for numbers, or `font-variant-numeric: tabular-nums` so scores don't jitter.
- **Size:** Xbox Accessibility Guideline 101 sets the mobile minimum at 18 px per 100 DPI ([XAG 101](https://learn.microsoft.com/en-us/xbox/accessibility/xbox-accessibility-guidelines/101)). Our reading of it: **≥ 14 CSS px for anything that carries information**. CrazyGames requires text legible at an 800×450 iframe with devicePixelRatio 1 ([gameplay](https://docs.crazygames.com/requirements/gameplay/)). Test there.
- **Over a busy 3D scene:** outline + soft shadow (`-webkit-text-stroke` / `text-shadow`), or a translucent plate behind the text.
- **HUD and menus in DOM over the canvas.** Sharpest, cheapest, accessible, and free tabular-nums. In-world labels: a canvas texture on a `Sprite`, redrawn when the text changes. Avoid `TextGeometry` (needs a typeface JSON, heavy geometry). Use `troika-three-text` only if you need crisp text that changes often in 3D (extra dependency).
- **Canvas waits for nothing.** Before the first `fillText` or canvas texture: `await document.fonts.load("700 48px 'Baloo 2'", "SKYHOLD")` ([MDN](https://developer.mozilla.org/en-US/docs/Web/API/FontFaceSet/load)).
- Keep all strings in one JSON file. English is mandatory on CrazyGames, and Poki recommends localisation for text-heavy games ([Poki](https://developers.poki.com/guide/localization)). Leave room for longer translations.

**Pairings** (display + UI, all OFL; licence files confirmed in `google/fonts/ofl/`)

| Vibe (styles) | Pairings |
|---|---|
| Cozy, rounded (1, 4) | **Baloo 2 + Nunito** (Skyhold, + JetBrains Mono for numbers) · Fredoka + Nunito · Fredoka + Quicksand |
| Punchy arcade (2, 3) | Lilita One + Rubik · Bungee + Rubik · Russo One + Rubik |
| Retro pixel (7) | Press Start 2P (headings only) + VT323 or Silkscreen · Pixelify Sans alone |
| Sci-fi, neon (6) | Orbitron + Exo 2 · Chakra Petch + Rajdhani · Orbitron + Space Grotesk |
| Clean minimal (5) | Outfit + Inter · Outfit + DM Sans |

**Browse for references:** [Game UI Database](https://www.gameuidatabase.com) (~2,000 games, filter by genre / colour / layout / screen type), [Interface In Game](https://interfaceingame.com) (by UI element and theme: Cartoon, Pixel art, Sci-Fi), [Fonts In Use](https://fontsinuse.com) (search "video game").

## Covers: type rules differ per portal

| | CrazyGames | Poki |
|---|---|---|
| Text | **Title only**, "in a nice and stylized font". No "New", "Play", etc. | **No text.** "Players prefer text-free thumbnails" |
| Sizes | 1920×1080 · 800×1200 · 800×800, consistent with each other | Full-bleed square ≥ 628×628 |
| Avoid | Borders, icons, store logos, blurry/pixelated images | Borders, padding, colours near `#83FFE7` (their page background) |

Both: one clear subject (main character mid-action), simple background, readable at tile size. Render covers from `?capture` with a title layer you can switch on and off per portal. Sources: [CrazyGames covers](https://docs.crazygames.com/requirements/game-covers/), [Poki thumbnail](https://developers.poki.com/guide/game-thumbnail).
