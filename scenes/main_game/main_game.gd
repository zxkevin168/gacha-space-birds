extends Node2D

@export var platform_scene: PackedScene
@export var enemy_scene: PackedScene
@export var max_jump = 30
@export var enemy_spawn_chance: float = 0.7  # 70% chance to spawn enemy on platform

@onready var last_platform: Node2D = $StartPlatform
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


    $SpawnTimer.start()
    var path: String = characters[Global.selected_character - 1]
    var player_character = load(path).instantiate()
    player_character.position = Vector2(240, 504)
    add_child(player_character)

    # Create and setup HUD
    var hud = CanvasLayer.new()
    var hud_script = load("res://scenes/hud/game_hud.gd")
    hud.set_script(hud_script)
    add_child(hud)

    # Connect HUD to player
    hud.connect_to_player(player_character)


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

    # Randomly spawn enemy on platform
    if enemy_scene and rng.randf() < enemy_spawn_chance:
        var enemy = enemy_scene.instantiate()
        # Position enemy on top of the platform relative to platform
        # Platform is 29 pixels tall, enemy is 50 pixels tall
        var enemy_x = rng.randf_range(20, 140)  # Random position on platform
        var enemy_y = -50  # On top of platform (relative to platform position)
        enemy.position = Vector2(enemy_x, enemy_y)
        platform.add_child(enemy)  # Make enemy a child of platform so it moves with it
