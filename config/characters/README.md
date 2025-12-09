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
    "jump_velocity": -400.0,
    "acceleration": 50.0
  },
  "description": "Character description"
}
```

## Stats Explanation

- **max_hp**: Maximum health points (displayed as hearts in the HUD)
- **speed**: Movement speed in pixels per second (functionally affects gameplay)
- **jump_velocity**: Jump force (negative value = upward force)
- **acceleration**: Movement acceleration rate

## How It Works

1. **Character Stats Loading**: When a character is instantiated in the game, it loads its stats from the corresponding JSON file in `/config/characters/knight{id}.json`

2. **Stats Class**: The `CharacterStats` class (`scripts/character_stats.gd`) handles:
   - Loading stats from JSON files
   - Managing current HP vs max HP
   - Emitting signals when HP changes
   - Providing helper methods (take_damage, heal, is_alive)

3. **Character Integration**: The `player_character.gd` script:
   - Loads stats based on the `character_id` property
   - Applies speed and jump_velocity to gameplay
   - Connects to HP change signals for UI updates

4. **HUD Display**: The game HUD (`scenes/hud/game_hud.gd`) displays:
   - HP as hearts (♥) in the top left corner
   - Filled hearts for current HP
   - Empty hearts for lost HP

## Adding New Characters

To add a new character:

1. Create a new JSON file: `knight3.json`
2. Define the character's stats following the format above
3. Create the character scene in `/characters/knight3.tscn`
4. Add the character to the `characters` array in `main_game.gd`
5. Add selection UI in `character_selection.gd`

## Modifying Existing Characters

Simply edit the JSON file for the character you want to modify. Changes will take effect the next time the character is loaded in the game.

No code changes are required when adjusting stats!
