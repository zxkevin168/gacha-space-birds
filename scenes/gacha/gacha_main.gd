extends Node2D

var pull_scene = preload("res://scenes/gacha/gacha_pulling_controller.tscn")
var in_action = false
var pull_child_scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if pull_child_scene:
        in_action = pull_child_scene.spinning
        if not in_action:
            $winning_name.text = pull_child_scene.winnings


func _on_button_pressed() -> void:
    if not in_action:
        if pull_child_scene:
            pull_child_scene.queue_free()
        pull_child_scene = pull_scene.instantiate()
        add_child(pull_child_scene)


func _on_main_menu_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/character_selection/character_selection.tscn")
