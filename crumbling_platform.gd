class_name Crumble extends StaticBody2D
@onready var _hitbox: Area2D = $Hitbox
@onready var _sprite: Sprite2D = $HouseDarkAlt2
var _optional_sprites:= [
	preload("res://Obstacles/houseDark.png"),
	preload("res://Obstacles/houseDarkAlt2.png"),
	preload("res://Obstacles/houseDarkAlt.png")
]
@onready var _sound: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var crumbling = true
@export var intact = false
var integrity = 10:
	set(num):
		if (num < integrity) and (num % 2 == 0):
			_sprite.modulate = _sprite.modulate.darkened(0.2)
			_sound.play([0.0, 1.44, 2.37, 4.02].pick_random())
			await get_tree().create_timer(0.9).timeout.connect(_sound.stop)
		integrity = num
		if integrity <= 0:
			queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !intact:
		crumbling = randf() < 0.5
	_sprite.texture = _optional_sprites.pick_random()
	if crumbling:
		_hitbox.area_entered.connect(func(body)-> void:
			if body.get_parent() is Player:
				integrity -= 1
		)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
