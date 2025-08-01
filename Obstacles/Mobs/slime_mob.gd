extends Mob
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var starting_position:= position
@onready var hitbox: Area2D = $Hitbox
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D



var _dir_right = false

func _ready() -> void:
	_sprite.play("walk")
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if position.x > starting_position.x + 100.0:
		_dir_right = false
		_sprite.flip_h = false
	if position.x < starting_position.x - 100.0:
		_dir_right = true
		_sprite.flip_h = true
	if _dir_right:
		position.x += speed * delta
	if !_dir_right:
		position.x -= speed * delta
	move_and_slide()
	
