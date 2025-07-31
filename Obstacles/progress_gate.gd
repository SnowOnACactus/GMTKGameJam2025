extends StaticBody2D
@onready var _door_collider: CollisionShape2D = $DoorCollider
@onready var _door_closed_mid: Sprite2D = $DoorClosedMid
@onready var _door_closed_top: Sprite2D = $DoorClosedTop
@onready var _door_open_top: Sprite2D = $DoorOpenTop
@onready var _door_open_mid: Sprite2D = $DoorOpenMid
@export var open = true:
	set(bool):
		open = bool
		_door_open_top.visible = bool
		_door_open_mid.visible = bool
		_door_closed_mid.visible = !bool
		_door_closed_top.visible = !bool
		_door_collider.disabled = bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
