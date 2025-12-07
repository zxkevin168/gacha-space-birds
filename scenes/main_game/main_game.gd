extends Node2D

@export var platform_scene: PackedScene
@export var max_jump = 30

@onready var last_platform: Node2D = $StartPlatform
var prev_platform_vector_y = 505
var rng = RandomNumberGenerator.new()
var characters: Array[String] = ["res://characters/knight1.tscn", "res://characters/knight2.tscn"]

func _ready() -> void:
    $SpawnTimer.start()
    var path: String = characters[Global.selected_character - 1]
    var player_character = load(path).instantiate()
    player_character.position = Vector2(240, 504)
    add_child(player_character)


func _process(_delta: float) -> void:
    pass

func _on_spawn_timer_timeout() -> void:
    var platform = platform_scene.instantiate()

    var spawn_position = last_platform.position
    spawn_position.x += 400
    const platform_height = 30
    var max_y = get_viewport().size.y - platform_height
    spawn_position.y = rng.randf_range(spawn_position.y - max_jump, max_y)

    platform.position = spawn_position
    add_child(platform)
    last_platform = platform
