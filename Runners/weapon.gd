class_name Sword extends Area2D
@onready var _sword_hitbox: CollisionShape2D = $SwordHitbox


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(kill)
	area_entered.connect(print)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func kill(body):
	if body is Mob:
		body.get_parent().die()
