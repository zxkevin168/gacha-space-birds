extends Node2D

@export var platform_scene: PackedScene

@onready var last_platform: Node2D = $InitialPlatform
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $PlatformSpawner.start()
    screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass


func _on_spawn_platform() -> void:
    var platform = platform_scene.instantiate()

    var spawn_position = last_platform.position
    spawn_position.x += 400
    const diff = 100
    spawn_position.y += randf_range(-diff, diff)
    const height = 30
    spawn_position.y = clamp(spawn_position.y, 0, screen_size.y - height)

    platform.position = spawn_position
    add_child(platform)
    last_platform = platform
