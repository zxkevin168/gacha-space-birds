extends Node2D

@export var platform_scene: PackedScene
@export var max_jump = 30
var prev_platform_vector_y = 505
var rng = RandomNumberGenerator.new()
var characters: Array[String] = ["res://characters/knight1.tscn", "res://characters/knight2.tscn"]
var backgrounds: Array[String] = [
	"res://scenes/backgrounds/space_purple.tscn",
	"res://scenes/backgrounds/space_blue.tscn",
	"res://scenes/backgrounds/space_red.tscn"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load selected background
	var bg_path: String = backgrounds[Global.selected_background - 1]
	var background = load(bg_path).instantiate()
	add_child(background)

	$spawn_timer.start()
	var path: String = characters[Global.selected_character - 1]
	var player_character = load(path).instantiate()
	player_character.position = Vector2(240, 504)
	add_child(player_character)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_spawn_timer_timeout() -> void:
	var platform = platform_scene.instantiate()
	var x = 1096
	var y = rng.randf_range(prev_platform_vector_y - max_jump, get_viewport().size.y)
	prev_platform_vector_y = y
	var spawn_location = Vector2(x, y)

	platform.position = spawn_location

	add_child(platform)
