extends CharacterBody2D

@export var speed = 300.0
@export var jump_velocity = -400.0

var direction = 0

func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.play()
	
	var static_speed = Vector2.ZERO

	# Move with the platform
	if is_on_floor():
		static_speed = get_slide_collision(0).get_collider().velocity

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		static_speed = Vector2.ZERO

	# Handle jump.
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, static_speed.x, speed)
	
	$AnimatedSprite2D.flip_h = false if direction >= 0 else true
		
	if velocity.y < 0:
		$AnimatedSprite2D.animation = "jumping"
	elif velocity.y > 0:
		$AnimatedSprite2D.animation = "falling"
	elif velocity.x == static_speed.x:
		$AnimatedSprite2D.animation = "idle"
	else:
		$AnimatedSprite2D.animation = "walking"
	

	move_and_slide()
