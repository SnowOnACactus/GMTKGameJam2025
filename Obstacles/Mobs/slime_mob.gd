extends Mob
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _starting_position:= position
var _dir_right = false

func _ready() -> void:
	_sprite.play("walk")
	
func _physics_process(delta: float) -> void:
	super(delta)
	if position.x > _starting_position.x + 100.0:
		_dir_right = false
		_sprite.flip_h = false
	if position.x < _starting_position.x - 100.0:
		_dir_right = true
		_sprite.flip_h = true
	if _dir_right:
		position.x += speed * delta
	if !_dir_right:
		position.x -= speed * delta
	
