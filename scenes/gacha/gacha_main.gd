extends Node2D

var pull_scene = preload("res://scenes/gacha/gacha_pulling_controller.tscn")
@onready var pull_child_scene = $GachaPullingController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if pull_child_scene and not pull_child_scene.spinning:
        $winning_name.text = pull_child_scene.winnings


func _on_button_pressed() -> void:
    if not pull_child_scene.spinning:
        pull_child_scene.start_single_pull()


func _on_main_menu_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/character_selection/character_selection.tscn")
