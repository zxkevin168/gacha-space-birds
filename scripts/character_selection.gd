extends Node2D

var selected = 1
var character_array
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character_array = {1: {"name": "Knight 1", "animation": $knight1_animation}, 2: {"name": "Knight 2", "animation": $knight2_animation}}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$selected_name.text = "You have selected: \n" + character_array[selected]["name"]
	for each in character_array:
		if each == selected:
			character_array[each]["animation"].play()
		else:
			character_array[each]["animation"].stop()

func _on_knight_1_button_pressed() -> void:
	selected = 1

func _on_knight_2_button_pressed() -> void:
	selected = 2

func _on_play_button_pressed() -> void:
	Global.selected_character = selected
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")
