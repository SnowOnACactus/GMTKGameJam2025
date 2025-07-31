class_name Mob extends CharacterBody2D
@export var speed: = 200.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
