extends Node2D

var selected_char = 1
var selected_bg = 1
var character_array
var background_array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character_array = {1: {"name": "Knight 1", "animation": $knight1_animation}, 2: {"name": "Knight 2", "animation": $knight2_animation}}
	background_array = {1: {"name": "Purple Space"}, 2: {"name": "Blue Space"}, 3: {"name": "Red Space"}}
	_update_bg_previews()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$selected_info.text = "Character: " + character_array[selected_char]["name"] + "\nBackground: " + background_array[selected_bg]["name"]
	for each in character_array:
		if each == selected_char:
			character_array[each]["animation"].play()
		else:
			character_array[each]["animation"].stop()

	_update_bg_previews()

func _update_bg_previews() -> void:
	$bg1_preview.modulate = Color(0.5, 0.5, 0.5, 1) if selected_bg != 1 else Color(1, 1, 1, 1)
	$bg2_preview.modulate = Color(0.5, 0.5, 0.5, 1) if selected_bg != 2 else Color(1, 1, 1, 1)
	$bg3_preview.modulate = Color(0.5, 0.5, 0.5, 1) if selected_bg != 3 else Color(1, 1, 1, 1)

func _on_knight_1_button_pressed() -> void:
	selected_char = 1

func _on_knight_2_button_pressed() -> void:
	selected_char = 2

func _on_bg_1_button_pressed() -> void:
	selected_bg = 1

func _on_bg_2_button_pressed() -> void:
	selected_bg = 2

func _on_bg_3_button_pressed() -> void:
	selected_bg = 3

func _on_play_button_pressed() -> void:
	Global.selected_character = selected_char
	Global.selected_background = selected_bg
	get_tree().change_scene_to_file("res://scenes/main_game/main_game.tscn")
