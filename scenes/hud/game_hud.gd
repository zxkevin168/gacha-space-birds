extends CanvasLayer

# Main HUD controller for the game
# Manages all UI elements like HP display

var hp_display: HBoxContainer
var player_character: CharacterBody2D

func _ready() -> void:
    # Create HP display container
    hp_display = HBoxContainer.new()
    hp_display.position = Vector2(20, 20)  # Top left corner

    # Attach the HP display script
    var script = load("res://scenes/hud/hp_display.gd")
    hp_display.set_script(script)

    add_child(hp_display)

# Connect to the player character to receive HP updates
func connect_to_player(player: CharacterBody2D) -> void:
    player_character = player

    # Wait for player's stats to be loaded
    if player.stats:
        _setup_hp_display()
    else:
        # If stats aren't loaded yet, wait a frame
        await get_tree().process_frame
        _setup_hp_display()

func _setup_hp_display() -> void:
    if player_character and player_character.stats:
        # Initialize HP display with current values
        hp_display.update_hp(player_character.stats.current_hp, player_character.stats.max_hp)

        # Connect to HP change signal
        player_character.stats.hp_changed.connect(_on_player_hp_changed)

func _on_player_hp_changed(new_hp: int, max_hp: int) -> void:
    hp_display.update_hp(new_hp, max_hp)
