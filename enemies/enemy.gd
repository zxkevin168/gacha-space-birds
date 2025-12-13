extends Area2D

var damage = 1
var bounce_time = 0.0
var patrol_speed = 30.0
var patrol_direction = 1  # 1 for right, -1 for left
var patrol_min = 10.0  # Minimum x position on platform
var patrol_max = 150.0  # Maximum x position on platform

func _ready() -> void:
	# Connect collision signal
	body_entered.connect(_on_body_entered)
	# Randomize starting direction
	patrol_direction = 1 if randf() > 0.5 else -1

func _process(delta: float) -> void:
	# Add a slight bounce animation to make it feel alive
	bounce_time += delta * 3
	var bounce_offset = sin(bounce_time) * 3
	$Sprite.position.y = bounce_offset

	# Patrol back and forth on the platform
	position.x += patrol_direction * patrol_speed * delta

	# Flip sprite based on direction
	if patrol_direction > 0:
		$Sprite.scale.x = 1
	else:
		$Sprite.scale.x = -1

	# Check boundaries and reverse direction
	if position.x >= patrol_max:
		patrol_direction = -1
	elif position.x <= patrol_min:
		patrol_direction = 1

func _on_body_entered(body: Node2D) -> void:
	# Check if the body is the player character
	if body.has_method("take_damage_from_enemy"):
		body.take_damage_from_enemy(damage)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# Clean up when enemy leaves the screen
	queue_free()
