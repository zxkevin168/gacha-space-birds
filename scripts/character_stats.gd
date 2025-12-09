extends Resource
class_name CharacterStats

# Character identification
var character_name: String = ""
var description: String = ""

# Character stats
var max_hp: int = 5
var current_hp: int = 5
var speed: float = 300.0
var jump_velocity: float = -400.0

# Signal for when HP changes (useful for UI updates)
signal hp_changed(new_hp: int, max_hp: int)

# Load character stats from JSON config file
static func load_from_config(character_id: int) -> CharacterStats:
	var stats = CharacterStats.new()
	var config_path = "res://config/characters/knight%d.json" % character_id

	if FileAccess.file_exists(config_path):
		var file = FileAccess.open(config_path, FileAccess.READ)
		var json_string = file.get_as_text()
		file.close()

		var json = JSON.new()
		var parse_result = json.parse(json_string)

		if parse_result == OK:
			var data = json.data
			stats.character_name = data.get("name", "Unknown")
			stats.description = data.get("description", "")

			if data.has("stats"):
				var stat_data = data["stats"]
				stats.max_hp = stat_data.get("max_hp", 5)
				stats.current_hp = stats.max_hp
				stats.speed = stat_data.get("speed", 300.0)
				stats.jump_velocity = stat_data.get("jump_velocity", -400.0)
		else:
			push_error("Error parsing character config: " + config_path)
	else:
		push_warning("Character config not found: " + config_path + ", using defaults")

	return stats

# Take damage
func take_damage(amount: int) -> void:
	current_hp = max(0, current_hp - amount)
	hp_changed.emit(current_hp, max_hp)

# Heal
func heal(amount: int) -> void:
	current_hp = min(max_hp, current_hp + amount)
	hp_changed.emit(current_hp, max_hp)

# Check if character is alive
func is_alive() -> bool:
	return current_hp > 0
