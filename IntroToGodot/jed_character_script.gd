extends CharacterBody2D

func _physics_process(delta: float) -> void:
	velocity.x = Input.get_axis("move_left", "move_right") * 50
	velocity.y = Input.get_axis("move_up", "move_down") * 50
	move_and_slide()
