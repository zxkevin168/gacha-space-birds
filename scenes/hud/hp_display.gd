extends HBoxContainer

# HP Display shows hearts representing the player's health
# Each heart represents 1 HP
const HEART_FULL = "\u2665"  # ♥ (filled heart)
const HEART_EMPTY = "\u2661"  # ♡ (empty heart)

var current_hp: int = 5
var max_hp: int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    update_display()

# Update the HP display
func update_hp(new_hp: int, new_max_hp: int) -> void:
    current_hp = new_hp
    max_hp = new_max_hp
    update_display()

# Refresh the heart display
func update_display() -> void:
    # Clear existing hearts
    for child in get_children():
        child.queue_free()

    # Create heart labels
    for i in range(max_hp):
        var heart_label = Label.new()
        heart_label.add_theme_font_size_override("font_size", 32)

        if i < current_hp:
            heart_label.text = HEART_FULL
            heart_label.modulate = Color(1, 0.2, 0.2)  # Red for filled hearts
        else:
            heart_label.text = HEART_EMPTY
            heart_label.modulate = Color(0.5, 0.5, 0.5)  # Gray for empty hearts

        add_child(heart_label)
