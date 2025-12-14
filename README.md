# Gacha Space Birds - Development Guide

## Table of Contents
1. [Project Overview](#project-overview)
2. [Project Structure](#project-structure)
3. [Core Systems](#core-systems)
4. [Common Tasks](#common-tasks)
5. [Configuration](#configuration)
6. [Best Practices](#best-practices)
7. [Troubleshooting](#troubleshooting)

---

## Project Overview

**Gacha Space Birds** is a 2D endless runner platformer built with Godot 4.5.

### Game Concept
Players select a character and background theme, then navigate across procedurally spawning platforms that move from right to left. The goal is to survive as long as possible by jumping between platforms.

### Technical Specs
- **Engine:** Godot 4.5
- **Viewport:** 1280x800 pixels
- **Platform:** 2D side-scroller
- **Genre:** Endless runner / Platformer

---

## Project Structure

```
gacha-space-birds/
├── characters/              # Player characters
│   ├── assets/             # Character sprite sheets
│   ├── knight1.tscn        # Knight character 1
│   ├── knight2.tscn        # Knight character 2
│   └── player_character.gd # Character controller
│
├── globals/
│   └── global.gd           # Global state (autoload)
│
├── platforms/              # Platform objects
│   ├── assets/            # Platform sprites
│   ├── floor.tscn         # Platform scene
│   └── floor.gd           # Platform script
│
├── scenes/
│   ├── backgrounds/        # Background themes
│   │   ├── space_purple.tscn
│   │   ├── space_blue.tscn
│   │   └── space_red.tscn
│   │
│   ├── character_selection/
│   │   ├── character_selection.tscn
│   │   └── character_selection.gd
│   │
│   └── main_game/
│       ├── main_game.tscn
│       ├── main_game.gd
│       └── star_sparkle.gd  # Star animation script
│
└── project.godot           # Project configuration
```

---

## Core Systems

### 1. Selection System

**Location:** `scenes/character_selection/`

#### Character Selection
- Choose between Knight 1 and Knight 2
- Character preview shows idle animation
- Selection stored in `Global.selected_character`

#### Background Selection
- Three space themes: Purple, Blue, Red
- Visual previews with color-coded boxes
- Selection stored in `Global.selected_background`
- Selected background highlighted, others dimmed

**Key Files:**
- `character_selection.gd:3-48` - Selection logic
- `character_selection.tscn:132-225` - UI layout
- `global.gd:3-4` - State storage

**How to Add Character:**
1. Create new character scene in `characters/` (duplicate knight1.tscn)
2. Add sprite sheets to `characters/assets/`
3. Update `character_array` in `character_selection.gd:10`
4. Add to `characters` array in `main_game.gd:7`
5. Add button and preview to `character_selection.tscn`

**How to Add Background:**
1. Create new background scene in `scenes/backgrounds/` (duplicate space_purple.tscn)
2. Update `backgrounds` array in `main_game.gd:8-12`
3. Update `background_array` in `character_selection.gd:11`
4. Add preview and button to `character_selection.tscn`

---

### 2. Background System

**Location:** `scenes/backgrounds/`

#### Three Background Themes

**Purple Space** (`space_purple.tscn`)
- Deep purple gradient (dark to light)
- White/purple moon with subtle craters
- 30 sparkling stars with warm tints

**Blue Space** (`space_blue.tscn`)
- Cool blue gradient (navy to light blue)
- Silver/blue moon with craters
- 30 sparkling stars with cool tints

**Red Space** (`space_red.tscn`)
- Warm red/crimson gradient
- Peachy-red moon with craters
- 30 sparkling stars with warm/red tints

#### Background Components

Each background contains:
- **Gradient Background** - Smooth 5-point vertical gradient
- **Moon** - Radial gradient sphere with 3 subtle craters
- **Stars** - 30 animated stars with sparkle effect

#### Dynamic Loading
Backgrounds are loaded dynamically based on player selection:

```gdscript
// main_game.gd:15-19
var bg_path: String = backgrounds[Global.selected_background - 1]
var background = load(bg_path).instantiate()
add_child(background)
```

---

### 3. Star Sparkle System

**Location:** `scenes/main_game/star_sparkle.gd`

#### Features
- **Opacity Animation:** Fades between 20% and 100%
- **Scale Pulsing:** Stars grow/shrink by 15%
- **Random Timing:** Each star has unique sparkle phase
- **Variable Speed:** Sparkle rate varies 1.5x - 3x per star

#### How It Works
```gdscript
// star_sparkle.gd:3-5
@export var min_opacity = 0.2
@export var max_opacity = 1.0
@export var sparkle_speed = 2.0
```

Each star gets random offset and speed on spawn, then animates using sine waves for smooth pulsing.

**To Modify Sparkle:**
- Adjust `min_opacity` / `max_opacity` for fade range
- Change `sparkle_speed` for faster/slower twinkling
- Edit scale calculation at line 26 for size variance

---

### 4. Player Movement System

**Location:** `characters/player_character.gd`

#### Controls
- **Left/Right Arrows:** Horizontal movement
- **Spacebar:** Jump (only when grounded)

#### Key Features
- Platform-relative movement - player moves with platform
- Gravity physics via CharacterBody2D
- State-based animations (idle, walking, jumping, falling)
- Character flips based on direction

#### Parameters
```gdscript
@export var speed = 300.0          // Horizontal movement
@export var jump_velocity = -400.0 // Jump strength
```

**Animation Logic** (`player_character.gd:35-42`):
- `velocity.y < 0` → jumping
- `velocity.y > 0` → falling
- `velocity.x == static_speed.x` → idle
- Otherwise → walking

---

### 5. Platform System

**Location:** `platforms/floor.gd` + `floor.tscn`

#### How Platforms Work
- Spawn at right edge (x=1096)
- Move left at constant speed
- Auto-delete when leaving screen
- Y position randomized within jump range

#### Spawn System (`main_game.gd:21-30`)
- Timer triggers every 5 seconds
- New platform spawns at right edge
- Y position constrained by `max_jump` from previous platform
- Prevents impossible jumps

#### Parameters
```gdscript
// floor.gd:3
@export var speed = 100  // Platform scroll speed

// main_game.gd:4
@export var max_jump = 30  // Max vertical distance between platforms
```

**To Adjust Difficulty:**
- Decrease spawn timer → more platforms (easier)
- Increase platform speed → faster scrolling (harder)
- Increase max_jump → larger gaps (harder)

---

### 6. Global State Management

**Location:** `globals/global.gd`

#### Current State Variables
```gdscript
var selected_character = 1  // 1 = Knight 1, 2 = Knight 2
var selected_background = 1 // 1 = Purple, 2 = Blue, 3 = Red
```

Access from any script: `Global.selected_character`

**To Add Global State:**
1. Add variable to `global.gd`
2. Access via `Global.variable_name`
3. Persists across scene transitions

---

## Common Tasks

### Changing Difficulty

**Easier:**
- Decrease `spawn_timer.wait_time` (more platforms)
- Decrease `floor.speed` (slower scrolling)
- Decrease `max_jump` (smaller gaps)

**Harder:**
- Increase `spawn_timer.wait_time` (fewer platforms)
- Increase `floor.speed` (faster scrolling)
- Increase `max_jump` (larger gaps)
- Decrease `player_character.jump_velocity` (weaker jump)

### Creating New Background

1. Duplicate `scenes/backgrounds/space_purple.tscn`
2. Rename to your theme (e.g., `space_green.tscn`)
3. Modify gradient colors in subresources
4. Adjust moon colors if desired
5. Update `main_game.gd:8-12` to include new path
6. Update `character_selection.gd:11` with theme name
7. Add preview UI in `character_selection.tscn`

### Adding Sound Effects

**Recommended formats:** WAV, OGG

1. Import audio files to project
2. Add AudioStreamPlayer nodes to scenes
3. Call `.play()` at appropriate times:
   - Jump: `player_character.gd:24`
   - Platform spawn: `main_game.gd:30`
   - Button clicks: `character_selection.gd` button functions

### Adding Score System

1. Add Label to `main_game.tscn`
2. Add `var score = 0` to `main_game.gd`
3. Increment score in `_on_spawn_timer_timeout()`
4. Update label: `$ScoreLabel.text = "Score: " + str(score)`

---

## Configuration

### Input Map
Located in `project.godot:28-44`

Current mappings:
- `move_right` → Right Arrow
- `move_left` → Left Arrow
- `move_jump` → Spacebar

**To modify:**
Project → Project Settings → Input Map

### Viewport Settings
Located in `project.godot:22-26`

```
window/size/viewport_width = 1280
window/size/viewport_height = 800
window/stretch/mode = "canvas_items"
```

---

## Best Practices

### Code Organization
1. **Use exports for tunables** - Makes values inspector-editable
2. **Use signals for events** - Better decoupling than direct calls
3. **Clean up nodes** - Always `queue_free()` dynamic objects
4. **Group related files** - Keep scene + script + assets together

### Signal Connections
- **Always connect signals in the Godot editor (scene `.tscn` files), not in `.gd` scripts.**
    - This ensures consistency, easier debugging, and clear separation between logic and scene structure.
    - To connect: select the node, go to the Node tab → Signals, and connect to the desired method.
    - The connection will appear in the `.tscn` file under `[connection ...]`.
    - Avoid using `signal.connect()` in GDScript except for dynamic or runtime-only cases.

### Naming Conventions
- **Scenes:** lowercase_with_underscores.tscn
- **Scripts:** lowercase_with_underscores.gd
- **Variables:** snake_case
- **Constants:** UPPER_SNAKE_CASE
- **Functions:** snake_case

### Testing
- **F5** - Run project from start
- **F6** - Run current scene
- **print()** - Debug output to console
- **breakpoint** - Pause execution (GDScript debugger)

### Performance
- Use object pooling for frequently spawned objects
- Minimize nodes in frequently instantiated scenes
- Use collision layers/masks efficiently
- Profile with Godot's built-in profiler

---

## Troubleshooting

### Player Falls Through Platforms
- Check collision layers match between player and platforms
- Verify CollisionShape2D is present and enabled
- Ensure StaticBody2D is used for platforms

### Animations Not Playing
- Verify AnimatedSprite2D.play() is called
- Check animation names match exactly (case-sensitive)
- Confirm sprite frames are loaded in SpriteFrames resource

### Background Not Loading
- Check `Global.selected_background` is set (1, 2, or 3)
- Verify background path in `main_game.gd:8-12`
- Ensure background scene files exist

### Stars Not Sparkling
- Confirm `star_sparkle.gd` is attached to star nodes
- Check star ColorRect nodes have script assigned
- Verify script hasn't been modified incorrectly

### Platform Spawning Issues
- Ensure timer is started in `main_game.gd:21`
- Verify `platform_scene` export is assigned
- Check spawn position calculations
- Add debug print in `_on_spawn_timer_timeout()`

---

## Scene Flow

```
[Start Game]
    ↓
character_selection.tscn
    ↓ (Select character and background)
    ↓ (Click "Play")
main_game.tscn
    ↓ (Loads selected background dynamically)
    ↓ (Spawns selected character)
    ↓ (Starts platform spawning)
[Gameplay Loop]
```

**To add new scenes:**
```gdscript
get_tree().change_scene_to_file("res://path/to/scene.tscn")
```

---

## Resources

### Godot Documentation
- [Godot 4 Docs](https://docs.godotengine.org/en/stable/)
- [CharacterBody2D Reference](https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html)
- [GDScript Language Reference](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/index.html)
- [2D Movement Tutorial](https://docs.godotengine.org/en/stable/tutorials/2d/2d_movement.html)

### This Project
- Characters use AnimatedSprite2D with SpriteFrames
- Platforms are StaticBody2D with constant velocity
- Backgrounds are CanvasLayer with layer=-1
- State managed through autoload singleton

---

## Version Info

- **Godot Version:** 4.5
- **Project Name:** Gacha Space Birds
- **Main Scene:** `character_selection.tscn`
- **Icon:** `icon.svg`

---

## Quick Reference

### File Locations

| What | Where |
|------|-------|
| Character logic | `characters/player_character.gd` |
| Platform logic | `platforms/floor.gd` |
| Game state | `globals/global.gd` |
| Main game loop | `scenes/main_game/main_game.gd` |
| Character selection | `scenes/character_selection/character_selection.gd` |
| Star animation | `scenes/main_game/star_sparkle.gd` |
| Backgrounds | `scenes/backgrounds/*.tscn` |

### Key Parameters

| Parameter | Location | Default | Purpose |
|-----------|----------|---------|---------|
| Player speed | `player_character.gd:3` | 300.0 | Horizontal movement speed |
| Jump velocity | `player_character.gd:4` | -400.0 | Jump strength |
| Platform speed | `floor.gd:3` | 100 | Platform scroll speed |
| Max jump | `main_game.gd:4` | 30 | Max platform gap |
| Spawn timer | `main_game.tscn:25` | 5.0 | Platform spawn interval |
| Star sparkle speed | `star_sparkle.gd:5` | 2.0 | Star twinkle speed |

---

*Last Updated: 2025-12-07*
