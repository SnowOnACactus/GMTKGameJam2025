@icon("res://Pickup/boxItem.png")
class_name Pickup extends Area2D
var random_item_array : Array[Dictionary] = [
	{"texture": preload("res://Obstacles/Mobs/flyFly1.png"), "scene": preload("res://Obstacles/Mobs/fly_mob.tscn")},
	{"texture": preload("res://Obstacles/Mobs/slimeWalk1.png"), "scene": preload("res://Obstacles/Mobs/slime_mob.tscn")},
	{"texture": preload("res://Obstacles/castleCenter_rounded.png"), "scene":preload("res://Obstacles/platform.tscn")}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func pick_random_item() -> Dictionary:
	return random_item_array.pick_random()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
