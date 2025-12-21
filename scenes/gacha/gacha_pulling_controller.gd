extends Control

@export var five_star_texture: Texture
@export var four_star_texture: Texture
@export var three_star_texture: Texture

var pull = preload("res://scenes/gacha/pull_object.tscn")
var selected
var winnings = ""

# rate is out off 1000
var five_star_rate = 250
var four_star_rate = 500

var spinning = false
const MAX_SCROLL_SPEED = 40
var scroll_speed = 0

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
    for i in range(0, 1000):
        if i % 10 <= 6:
            create_item("three_star")
        elif i % 10 > 6 and i % 10 <= 8:
            create_item("four_star")
        else:
            create_item("five_star")

func create_item(item_type: String):
    var img = pull.instantiate()
    img.texture = gacha_info[item_type]["texture"]
    $ScrollContainer/HBoxContainer.add_child(img)

func start_single_pull():
    $ScrollContainer.scroll_horizontal = 0
    spinning = true
    scroll_speed = MAX_SCROLL_SPEED
    var pull_id = randi_range(1, 1000)
    if pull_id <= five_star_rate:
        winnings = "five_star"
    elif pull_id <= four_star_rate:
        winnings = "four_star"
    else:
        winnings = "three_star"
    print(winnings)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if spinning:
        $ScrollContainer.scroll_horizontal += scroll_speed
    if scroll_speed == 0:
        spinning = false


func _on_timer_timeout() -> void:
    if spinning:
        if scroll_speed > 3:
            scroll_speed -= 1
        elif scroll_speed <= 3 and selected == gacha_info[winnings]["texture"]:
            scroll_speed -= 1
            scroll_speed = max(0, scroll_speed)
        else:
            scroll_speed -= 0.25
            scroll_speed = max(3, scroll_speed)


func _on_area_2d_area_entered(area: Area2D) -> void:
    selected = area.get_parent().texture
