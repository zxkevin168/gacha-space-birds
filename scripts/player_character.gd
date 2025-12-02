extends CharacterBody2D

@export var speed = 300.0
@export var jump_velocity = -400.0

var direction = 0

func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.play()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	$AnimatedSprite2D.flip_h = false if direction >= 0 else true
		
	if velocity.y > 0:
		$AnimatedSprite2D.animation = "jumping"
	elif velocity.y < 0:
		$AnimatedSprite2D.animation = "falling"
	elif velocity.x != 0:
		$AnimatedSprite2D.animation = "walking"
	elif velocity.x == 0:
		$AnimatedSprite2D.animation = "idle"

	move_and_slide()
