extends CharacterBody2D

# Character ID to load stats from config
@export var character_id: int = 1

# Default values (will be overridden by config)
@export var speed = 300.0
@export var jump_velocity = -400.0

var direction = 0
var stats: CharacterStats

func _ready() -> void:
	# Load character stats from config
	stats = CharacterStats.load_from_config(character_id)

	# Apply stats to character
	speed = stats.speed
	jump_velocity = stats.jump_velocity

	# Connect to HP change signal for future UI updates
	stats.hp_changed.connect(_on_hp_changed)

func _on_hp_changed(new_hp: int, max_hp: int) -> void:
	# Check if character died from HP loss
	if new_hp <= 0:
		_handle_death()

func _die_from_fall() -> void:
	# Character fell off the screen
	if stats:
		stats.current_hp = 0
		stats.hp_changed.emit(0, stats.max_hp)
	_handle_death()

func _handle_death() -> void:
	# Handle character death
	# Store reference to scene tree before disabling anything
	var tree = get_tree()
	if not tree:
		return

	# Disable physics processing to stop movement
	set_physics_process(false)

	# Wait a moment before showing game over screen
	await tree.create_timer(0.5).timeout

	# Check tree is still valid before changing scene
	if tree:
		tree.change_scene_to_file("res://scenes/game_over/game_over.tscn")

func _physics_process(delta: float) -> void:
	# Check if character has fallen off screen
	if position.y > get_viewport_rect().size.y + 100:
		_die_from_fall()
		return

	# Check if character is dead
	if stats and not stats.is_alive():
		_handle_death()
		return

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
		$AnimatedSprite2D.flip_h = false if direction >= 0 else true
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, static_speed.x, speed)
	
	
	if velocity.y < 0:
		$AnimatedSprite2D.animation = "jumping"
	elif velocity.y > 0:
		$AnimatedSprite2D.animation = "falling"
	elif velocity.x == static_speed.x:
		$AnimatedSprite2D.animation = "idle"
	else:
		$AnimatedSprite2D.animation = "walking"
	

	move_and_slide()
