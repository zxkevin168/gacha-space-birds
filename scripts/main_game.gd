extends Node2D

@export var platform_scene: PackedScene
@export var max_jump = 30
var prev_platform_vector_y = 505
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$spawn_timer.start() # Replace with function body.

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
