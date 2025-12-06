extends StaticBody2D

var speed = 100

func _ready() -> void:
    pass


func _process(delta: float) -> void:
    var velocity = Vector2(-1, 0) * speed * delta
    position += velocity


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
    queue_free()
