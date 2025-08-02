@icon("res://Pickup/boxItem.png")
class_name Pickup extends Area2D

# Here is the list of possible obstacles and the texture used by the player's thought bubble
var random_item_array : Array[Dictionary] = [
	{"texture": preload("res://Obstacles/Mobs/flyFly1.png"), "scene": preload("res://Obstacles/Mobs/fly_mob.tscn")},
	{"texture": preload("res://Obstacles/Mobs/slimeWalk1.png"), "scene": preload("res://Obstacles/Mobs/slime_mob.tscn")},
	#{"texture": preload("res://Obstacles/castleCenter_rounded.png"), "scene":preload("res://Obstacles/platform.tscn")},
	#{"texture": preload("res://Obstacles/spikes.png"), "scene": preload("res://Obstacles/spike_trap.tscn")},
	#{"texture": preload("res://Obstacles/shroomRedAltLeft.png"), "scene": preload("res://Obstacles/bouncy_mushroom.tscn")},
	#{"texture": preload("res://Obstacles/Mobs/ghost.png"), "scene": preload("res://Obstacles/Mobs/ghost.tscn")}
]
@onready var _possible_obstacle: Sprite2D = $PossibleObstacle
@onready var _timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_timer.timeout.connect(func() -> void: _possible_obstacle.texture = _pick_new_texture())

func _pick_new_texture() -> Texture:
	var new_texture = pick_random_item().texture
	if new_texture == _possible_obstacle.texture:
		return _pick_new_texture()
	return new_texture

func pick_random_item() -> Dictionary:
	return random_item_array.pick_random()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
