# Character Attributes Configuration

This directory contains JSON configuration files for character stats and attributes.

## File Structure

Each character has its own JSON config file:
- `knight1.json` - Configuration for Knight 1
- `knight2.json` - Configuration for Knight 2

## Configuration Format

```json
{
  "name": "Character Name",
  "stats": {
    "max_hp": 5,
    "speed": 300.0,
    "jump_velocity": -400.0
  },
  "description": "Short character description"
}
```

## Config Fields

- **name**: Character display name (shown in selection screen)
- **description**: Short description (shown in selection screen)
- **stats**: Gameplay statistics object

## Stats Explanation

- **max_hp**: Maximum health points (displayed as hearts in the HUD)
- **speed**: Movement speed in pixels per second (functionally affects gameplay)
- **jump_velocity**: Jump force (negative value = upward force)

## How It Works

1. **Character Stats Loading**: When a character is instantiated, it loads stats from `/config/characters/knight{id}.json`

2. **Stats Class** (`scripts/character_stats.gd`):
   - Loads stats from JSON files
   - Manages current HP vs max HP
   - Emits signals when HP changes
   - Provides helper methods: `take_damage()`, `heal()`, `is_alive()`

3. **Character Integration** (`characters/player_character.gd`):
   - Loads stats based on `character_id` property
   - Applies speed and jump_velocity to gameplay
   - Handles death when HP reaches 0 or falling off screen
   - Connects to HP change signals for UI updates

4. **Selection Screen** (`scenes/character_selection/character_selection.gd`):
   - Displays character name, description, and stats
   - Shows HP, Speed, and Jump values from config
   - Updates info when switching characters/backgrounds

5. **HUD Display** (`scenes/hud/game_hud.gd`):
   - Shows HP as hearts (♥) in the top left corner
   - Filled red hearts for current HP
   - Empty gray hearts for lost HP
   - Updates in real-time when HP changes

## Gameplay Features

- **Fall Death**: Characters die (HP → 0) when falling off screen
- **Scene Reload**: Death triggers automatic scene reload after 0.5s delay
- **Speed Differences**: Each character moves at their configured speed
- **Different Playstyles**: Configure characters as glass cannons, tanks, balanced, etc.

## Adding New Characters

To add a new character:

1. Create a new JSON config: `knight3.json`
2. Define stats following the format above
3. Create the character scene with sprites: `/characters/knight3.tscn`
4. Add to the `characters` array in `main_game.gd`
5. Add selection UI in `character_selection.gd`

**Note**: Character sprites are defined in the `.tscn` scene files, not in config. This is the standard Godot approach for better performance and editor integration.

## Modifying Existing Characters

Simply edit the JSON file to adjust stats. Changes take effect when the character loads.

**No code changes required when adjusting stats!**
