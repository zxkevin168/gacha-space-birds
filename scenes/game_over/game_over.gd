extends Control

func _ready() -> void:
    # Wait 2 seconds before transitioning to character selection
    await get_tree().create_timer(2.0).timeout
    get_tree().change_scene_to_file("res://scenes/character_selection/character_selection.tscn")
