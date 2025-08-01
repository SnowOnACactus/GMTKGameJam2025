extends Mob
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var starting_position:= position
@onready var hitbox: Area2D = $Hitbox
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

var _dir_right = false
var _dir_up = false

func _ready() -> void:
	_sprite.play("fly")

func _physics_process(delta: float) -> void:
	super(delta)
	if position.x > starting_position.x + 100.0:
		_dir_right = false
		_sprite.flip_h = true 
		#comments
	if position.x < starting_position.x - 100.0:
		_dir_right = true
		_sprite.flip_h = true
	if position.y < starting_position.y - 50.0:
		_dir_up = false
	if position.y > starting_position.y + 50.0:
		_dir_up = true
	if _dir_right:
		position.x += speed * delta
	if !_dir_right:
		position.x -= speed * delta
	if _dir_up:
		position.y -= speed * delta
	if !_dir_up:
		position.y += speed * delta
	
