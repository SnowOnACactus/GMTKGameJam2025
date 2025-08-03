extends Mob
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var starting_position:= position
@onready var hitbox: Area2D = $Hitbox
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var _dir_right = false
var _dir_up = true
var dead = false

func _ready() -> void:
	_sprite.play("fly")
	hitbox.area_entered.connect(
		func(body) -> void: 
			if (body.get_parent() is Hurt and body.get_parent().get_parent() is GameScene) or body is Sword:
				die()
	)

func _physics_process(delta: float) -> void:
	if !dead:
		if position.x > starting_position.x + 150.0:
			_dir_right = false
			_sprite.flip_h = false
		if position.x < starting_position.x - 150.0:
			_dir_right = true
			_sprite.flip_h = true
		if position.y < starting_position.y - 25.0:
			_dir_up = false
		if position.y > starting_position.y + 25.0:
			_dir_up = true

		if _dir_right:
			position.x += speed * delta
		if !_dir_right:
			position.x -= speed * delta
		
		if _dir_up:
			position.y -= (speed/4) * delta
		if !_dir_up:
			position.y += (speed/4) * delta
		
		move_and_slide()
	if dead: position.y += 300 * delta

func die() -> void:
	_sprite.play("die")
	collision_shape_2d.disabled = true
	collision_layer = 0
	collision_mask = 0
	hitbox.collision_layer = 0
	hitbox.collision_mask = 0
	hitbox.monitorable = false
	hitbox.monitoring = false
	dead = true
	get_tree().create_timer(1.5).timeout.connect(queue_free)
