extends Mob
const GHOST = preload("res://Obstacles/Mobs/ghost.png")
const GHOST_DEAD = preload("res://Obstacles/Mobs/ghost_dead.png")
const GHOST_HIT = preload("res://Obstacles/Mobs/ghost_hit.png")
const SPEED = 50.0
@onready var _sprite_2d: Sprite2D = $Sprite2D
@onready var player = get_node("../Runner")
@onready var hitbox: Area2D = $Hitbox
# This isn't needed to function - but it's called by the player because it's a mob
var starting_position:= Vector2.ZERO

var _facing_right:= false:
	set(bool):
		_facing_right = bool
		_sprite_2d.flip_h = bool

func _physics_process(delta: float) -> void:
	if (player.faced_right and position.x < player.position.x) or (!player.faced_right and position.x > player.position.x):
		velocity = Vector2.ZERO
	else:
		velocity = position.direction_to(player.position)
		velocity.x *= SPEED
		velocity.y *= SPEED
		print(velocity)
	move_and_slide()
