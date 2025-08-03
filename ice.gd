class_name Slippery extends StaticBody2D
var textures:= [
	preload("res://Obstacles/iceBlock.png"),
	preload("res://Obstacles/iceBlockAlt.png")
]
@onready var _ice_block_2: Sprite2D = $IceBlock2
@onready var _ice_block: Sprite2D = $IceBlock

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_ice_block.texture = textures.pick_random()
	_ice_block_2.texture = textures.pick_random()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
