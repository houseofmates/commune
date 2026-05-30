<h1 align="center">commune</h1>

<p align="center">
  <strong>a socialist/communist-themed idle/incremental game</strong><br>
</p>

<p align="center">
  <a href="#what-is-the-commune">what is the commune?</a> •
  <a href="#features">features</a> •
  <a href="#architecture">architecture</a> •
  <a href="#game-systems">game systems</a> •
  <a href="#getting-started">getting started</a> •
  <a href="#art-direction">art direction</a> •
  <a href="#development">development</a> •
  <a href="#license">license</a>
</p>

<hr>

<h2 align="center" id="what-is-the-commune">what is the commune?</h2>

<p align="center">the commune is a top‑down idle/incremental game where you build and manage a self‑sustaining worker community. place buildings, assign labour, and watch your commune grow from a single house into a thriving collective. every resource is shared, every worker matters, and the goal is simple: from each according to their ability, to each according to their need.</p>

<p align="center"><strong>core philosophy</strong></p>

<div align="center">
<table>
  <thead>
    <tr><th>principle</th><th>what it means in practice</th></tr>
  </thead>
  <tbody>
    <tr><td>idle‑first</td><td>production continues even when you close the game — offline gains are calculated on return</td></tr>
    <tr><td>worker‑centric</td><td>every building can be assigned workers; efficiency scales with your decisions</td></tr>
    <tr><td>zero‑sum economy</td><td>nothing is created from nothing — every loaf of bread costs wheat, every plank costs logs</td></tr>
    <tr><td>single‑player</td><td>one commune, one save, no login, no cloud — just you and your comrades</td></tr>
    <tr><td>mobile‑first</td><td>designed for portrait touch screens, exportable to android apk and linux appimage</td></tr>
  </tbody>
</table>
</div>

<blockquote align="center">the entire codebase is written in gdscript for godot 4.3, with data‑driven building and resource definitions stored as json.</blockquote>

<hr>

<h2 align="center" id="features">features</h2>

<h3 align="center" id="production-chains">full production chains</h3>

- 14 buildings: house, farm, forester's hut, quarry, mine, sheep farm, mill, sawmill, stonemason, smelter, bakery, workshop, blacksmith, tailor, and a monument to labour
- 13 resources: wheat, logs, stone, iron ore, wool, flour, planks, stone blocks, iron ingots, bread, furniture, tools, clothing
- every product requires real inputs — the commune’s economy is a closed, balanced system

<h3 align="center" id="worker-management">worker management</h3>

- workers are spawned from houses and can be assigned to any production building
- worker efficiency multiplies a building’s output — more workers, more production
- workers walk between resource nodes and processing buildings with full idle/walk animations

<h3 align="center" id="idle-progression">idle progression</h3>

- a 1‑second game tick aggregates production and consumption
- offline gains are calculated automatically when you reload a save
- autosave every 60 seconds, with a subtle save indicator

<h3 align="center" id="building-upgrades">building upgrades</h3>

- every building can be upgraded multiple times, increasing output, worker capacity, and visual level
- upgrade costs scale exponentially — later levels require careful planning
- some buildings unlock only after your commune reaches a certain labour‑voucher threshold

<h3 align="center" id="comrade-john">comrade john</h3>

- your player character is stylized after john holmes: brown curly hair, moustache, blue eyes, 70s v‑neck shirt, bell‑bottom pants
- procedurally animated idle and walk cycles
- single‑finger drag‑to‑move control, perfectly tuned for mobile

<h3 align="center" id="ui-and-ux">ui & ux</h3>

- building menu with animated toggle, cost previews, and unlock states
- building management panel: upgrade, assign workers, demolish
- resource bar shows all 13 resources with smooth animations
- tutorial overlay for first‑time players
- settings panel with volume sliders and save erasure
- day/night cycle overlay (purely cosmetic)
- title screen with new game / continue / settings flow

<h3 align="center" id="victory-condition">monument to labor</h3>

- an optional victory condition: build the monument for 1,000,000 labor vouchers
- a real‑time 10‑minute construction timer with a progress bar
- on completion: a congratulatory screen with scrolling credits and a “continue playing” option

<hr>

<h2 align="center" id="architecture">architecture</h2>

<pre align="center"><code>commune/
├── assets/
│   ├── fonts/                  # varela round (primary ui font)
│   └── sprites/               # placeholder png assets (buildings, resources, ui)
├── data/
│   ├── buildings.json         # building definitions (cost, production, upgrades)
│   └── resources.json         # resource definitions (icons, colours, max storage)
├── scenes/
│   ├── Main.tscn              # main scene (world + ui layers)
│   ├── TitleScreen.tscn       # title screen with new/continue/settings
│   ├── World.tscn             # game world (tilemap, buildings, characters)
│   ├── buildings/             # individual building scenes (farm, bakery, etc.)
│   ├── character/             # player and worker scenes
│   └── ui/                    # hud, building menu, tutorial, etc.
├── scripts/
│   ├── autoloads/             # global singletons
│   │   ├── EventBus.gd        # signal bus for decoupled communication
│   │   ├── GameState.gd       # resource totals, building list, worker state
│   │   ├── ResourceManager.gd # 1‑second game tick, production/consumption
│   │   ├── SaveManager.gd     # json save/load, offline gain calculation
│   │   └── AudioManager.gd    # ambient drone, procedural beep sounds
│   ├── buildings/             # per‑building logic (upgrades, efficiency)
│   ├── character/             # player controller, worker ai, animations
│   ├── ui/                    # hud, menus, overlays, effects
│   └── world/                 # building placer, camera, resource nodes
├── project.godot              # godot project configuration
├── Makefile                   # run, import, export targets
└── README.md
</code></pre>

<h3 align="center" id="autoloads">autoload singletons</h3>

<div align="center">
<table>
  <thead>
    <tr><th>singleton</th><th>responsibility</th></tr>
  </thead>
  <tbody>
    <tr><td><code>EventBus</code></td><td>typed signals for all cross‑system communication</td></tr>
    <tr><td><code>GameState</code></td><td>resource totals, building data, worker counts, save metadata</td></tr>
    <tr><td><code>ResourceManager</code></td><td>1‑second tick: aggregates building production/consumption and applies to GameState</td></tr>
    <tr><td><code>SaveManager</code></td><td>json save/load with deferred building rehydration and offline gain calculation</td></tr>
    <tr><td><code>AudioManager</code></td><td>ambient drone generation and event‑triggered beeps (procedural sine‑wave synthesis)</td></tr>
  </tbody>
</table>
</div>

<h3 align="center" id="data-flow">data flow</h3>

<pre align="center"><code>┌─────────────┐     ┌──────────────────┐     ┌───────────────┐
│   player    │────▶│  building menu   │────▶│  building     │
│  (drag to   │     │  (select, cost   │     │  placer       │
│   move)     │     │   check)         │     │  (tap to      │
└─────────────┘     └──────────────────┘     │   place)      │
                                             └───────┬───────┘
                                                     │
┌─────────────┐     ┌──────────────────┐     ┌───────▼───────┐
│  resource   │◀────│  resource        │◀────│  game state   │
│  bar (ui)   │     │  manager (tick)  │     │  (resources,  │
│  shows      │     │  every 1 second  │     │   buildings)  │
│  totals     │     │  aggregates      │     │               │
└─────────────┘     │  prod/cons       │     └───────┬───────┘
                    └──────────────────┘             │
                                                     │
┌─────────────┐     ┌──────────────────┐     ┌───────▼───────┐
│  save file  │◀────│  save manager    │◀────│  autosave     │
│  (json)     │     │  load: rehydrate │     │  (every 60s)  │
│             │     │  buildings then  │     │               │
│             │     │  offline gains   │     │               │
└─────────────┘     └──────────────────┘     └───────────────┘
</code></pre>

1. **player input** — drag to move, tap to interact. ui consumes touch events so movement never interferes with menus.
2. **building placement** — after verifying full cost, the building is instantiated and registered in game state.
3. **game tick** — every second, resource manager sums all buildings’ production and consumption, applies them to game state, and updates the ui.
4. **save/load** — game state is serialised to json. on load, building nodes are recreated first, then offline gains are calculated and applied.

<hr>

<h2 align="center" id="game-systems">game systems</h2>

<h3 align="center" id="production--consumption">production & consumption</h3>

- each building has a production dictionary (what it creates) and a consumption dictionary (what it requires)
- rates are multiplied by building level and worker efficiency
- resource manager ensures production is gated — if inputs are insufficient, output is scaled down proportionally

<h3 align="center" id="workers-and-efficiency">workers and efficiency</h3>

- workers are spawned from houses (2 per house, upgradable to 4)
- assign workers to buildings via the building management panel
- efficiency = assigned workers / worker capacity (clamped 0‑1)
- worker npcs walk between resource nodes and processing buildings with idle/walk animations

<h3 align="center" id="save-system">save system</h3>

- saves to `user://commune_save.json`
- stores resources, building states (level, workers, position), tutorial completion, and timestamp
- on load: building nodes are instantiated, production rates recalculated, then offline gains applied based on elapsed time
- autosave every 60 seconds with a subtle floppy‑disk icon

<h3 align="center" id="audio">audio</h3>

- ambient drone: low‑frequency sine wave (60 Hz) with slow lfo modulation
- procedural beeps: building placed (440 Hz), upgraded (880 Hz), resource change (220 Hz)
- ui click: 330 Hz, 0.03 seconds
- all sounds generated in‑engine via `AudioStreamGenerator` — no audio files needed

<hr>

<h2 align="center" id="getting-started">getting started</h2>

<h3 align="center" id="prerequisites">prerequisites</h3>

- godot engine 4.3 (forward+ renderer recommended)

<h3 align="center" id="running">running</h3>

<pre align="center"><code>make run</code></pre>

<p align="center">this opens the project in the godot editor and runs the main scene. for headless testing:</p>

<pre align="center"><code>godot --headless --path . --script scripts/generate_assets.gd   # regenerate placeholder pngs
godot --headless --path . --scene scenes/Main.tscn              # headless run (no window)
</code></pre>

<h3 align="center" id="exporting">exporting</h3>

<pre align="center"><code>make export-android   # creates an apk for android
make export-linux    # creates an appimage for linux
</code></pre>

<p align="center">export presets are defined in <code>export_presets.cfg</code> — android (com.houseofmates.commune) and linux (x86_64).</p>

<hr>

<h2 align="center" id="art-direction">art direction</h2>

<h3 align="center" id="character">character (comrade john)</h3>

- **hair**: brown, curly
- **face**: thick brown moustache, blue eyes
- **clothing**: pale yellow 70s high‑collared v‑neck shirt with subtle darker v pattern, blue bell‑bottom pants, dark brown dress shoes
- **animation**: idle breathing and walk cycle, all procedurally generated in gdscript

<h3 align="center" id="world">world</h3>

- **perspective**: top‑down 2d with simulated depth (drop shadows, sorted y‑ordering)
- **colour palette**: pk‑m inspired — #050505 background, #ffaf00 gold accents, #3c9fdd accent blue
- **buildings**: cream plaster walls, terracotta tile roofs, gold (#ffaf00) timber framing and star motifs
- **ui**: varela round font, strictly lowercase, physics‑based transitions, 8‑point spacing grid

<hr>

<h2 align="center" id="development">development</h2>

<h3 align="center" id="commands">commands</h3>

<div align="center">
<table>
  <thead>
    <tr><th>command</th><th>what it does</th></tr>
  </thead>
  <tbody>
    <tr><td><code>make run</code></td><td>open project in godot editor and run</td></tr>
    <tr><td><code>make import</code></td><td>import assets and generate sprites</td></tr>
    <tr><td><code>make export-android</code></td><td>build android apk</td></tr>
    <tr><td><code>make export-linux</code></td><td>build linux appimage</td></tr>
    <tr><td><code>make clean</code></td><td>remove build artifacts</td></tr>
  </tbody>
</table>
</div>

<h3 align="center" id="data-driven-design">data‑driven design</h3>

- edit `data/buildings.json` and `data/resources.json` to add new buildings, tweak costs, or balance production rates
- no code changes needed for new content — the game reads these files at runtime

<h3 align="center" id="testing">testing</h3>

- use godot’s built‑in debugger and remote scene tree for real‑time inspection
- headless mode (`--headless`) works for automated testing and asset generation

<h3 align="center" id="conventions">conventions</h3>

- **lowercase ui** — all user‑facing text is lowercase
- **gdscript** — static typing preferred, `class_name` for all reusable scripts
- **signals** — all cross‑system communication uses `EventBus`
- **path references** — always `res://` relative, no hard‑coded absolute paths

<hr>

<h2 align="center" id="license">license</h2>

<div align="center">
  <a href="./license">mates license</a>
</div>
