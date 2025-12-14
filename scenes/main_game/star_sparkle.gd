extends ColorRect

@export var min_opacity = 0.2
@export var max_opacity = 1.0
@export var sparkle_speed = 2.0

var time = 0.0
var offset = 0.0
var scale_time = 0.0

func _ready() -> void:
    # Random offset so stars don't all sparkle in sync
    offset = randf() * TAU
    # Random sparkle speed variation
    sparkle_speed = randf_range(1.5, 3.0)

func _process(delta: float) -> void:
    time += delta * sparkle_speed
    scale_time += delta * sparkle_speed * 0.5

    # Use sine wave for smooth sparkle effect with more dramatic changes
    var alpha = lerp(min_opacity, max_opacity, (sin(time + offset) + 1.0) / 2.0)
    modulate.a = alpha

    # Subtle pulsing scale for extra sparkle
    var scale_factor = 1.0 + sin(scale_time + offset) * 0.15
    scale = Vector2(scale_factor, scale_factor)
