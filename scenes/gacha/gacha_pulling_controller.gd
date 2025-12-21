extends Control

@export var five_star_texture: Texture
@export var four_star_texture: Texture
@export var three_star_texture: Texture

var pull = preload("res://scenes/gacha/pull_object.tscn")
var selected
var winnings

# rate is out off 1000
var five_star_rate = 250
var four_star_rate = 500

var spinning = true
var scroll_speed = 40

@onready var gacha_info = {
    "five_star": {
        "texture": five_star_texture
    },
    "four_star": {
        "texture": four_star_texture
    },
    "three_star": {
        "texture": three_star_texture
    }
}

func _ready() -> void:
    $Timer.start()
    for i in range(1, 1001):
        if i % 10 > 0 and i % 10 <= 7:
            create_item("three_star")
        elif i % 10 > 7 and i % 10 <= 9:
            create_item("four_star")
        else:
            create_item("five_star")
    var pull_id = randi_range(1, 1000)
    if pull_id <= five_star_rate:
        winnings = "five_star"
    elif pull_id <= four_star_rate:
        winnings = "four_star"
    else:
        winnings = "three_star"
    print(winnings)

func create_item(item_type: String):
    var img = pull.instantiate()
    img.texture = gacha_info[item_type]["texture"]
    $ScrollContainer/HBoxContainer.add_child(img)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    $ScrollContainer.scroll_horizontal += scroll_speed
    if scroll_speed == 0:
        spinning = false


func _on_timer_timeout() -> void:
    if scroll_speed <= 3 and selected == gacha_info[winnings]["texture"]:
        scroll_speed -= 1
        scroll_speed = max(0, scroll_speed)
    elif scroll_speed > 15:
        scroll_speed -= 1
    else:
        scroll_speed -= 0.25
        scroll_speed = max(3, scroll_speed)


func _on_area_2d_area_entered(area: Area2D) -> void:
    selected = area.get_parent().texture
