extends Node2D

var selected_char = 1
var selected_bg = 1
var character_array
var background_array
var character_stats: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    # Load character stats from config files
    character_stats[1] = CharacterStats.load_from_config(1)
    character_stats[2] = CharacterStats.load_from_config(2)

    character_array = {1: {"name": "Knight 1", "animation": $knight1_animation}, 2: {"name": "Knight 2", "animation": $knight2_animation}}
    background_array = {1: {"name": "Purple Space"}, 2: {"name": "Blue Space"}, 3: {"name": "Red Space"}}
    _update_bg_previews()
    _update_character_info()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    for each in character_array:
        if each == selected_char:
            character_array[each]["animation"].play()
        else:
            character_array[each]["animation"].stop()

    _update_bg_previews()

func _update_character_info() -> void:
    var stats = character_stats[selected_char]
    var info_text = stats.character_name
    info_text += "\n" + stats.description
    info_text += "\n"
    info_text += "\nHP: " + str(stats.max_hp) + "  |  Speed: " + str(int(stats.speed)) + "  |  Jump: " + str(int(abs(stats.jump_velocity)))
    info_text += "\n\nBackground: " + background_array[selected_bg]["name"]

    $selected_info.text = info_text

func _update_bg_previews() -> void:
    $bg1_preview.modulate = Color(0.5, 0.5, 0.5, 1) if selected_bg != 1 else Color(1, 1, 1, 1)
    $bg2_preview.modulate = Color(0.5, 0.5, 0.5, 1) if selected_bg != 2 else Color(1, 1, 1, 1)
    $bg3_preview.modulate = Color(0.5, 0.5, 0.5, 1) if selected_bg != 3 else Color(1, 1, 1, 1)

func _on_knight_1_button_pressed() -> void:
    selected_char = 1
    _update_character_info()

func _on_knight_2_button_pressed() -> void:
    selected_char = 2
    _update_character_info()

func _on_bg_1_button_pressed() -> void:
    selected_bg = 1
    _update_character_info()

func _on_bg_2_button_pressed() -> void:
    selected_bg = 2
    _update_character_info()

func _on_bg_3_button_pressed() -> void:
    selected_bg = 3
    _update_character_info()

func _on_play_button_pressed() -> void:
    Global.selected_character = selected_char
    Global.selected_background = selected_bg
    get_tree().change_scene_to_file("res://scenes/main_game/main_game.tscn")


func _on_gacha_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/gacha/gacha_main.tscn")
