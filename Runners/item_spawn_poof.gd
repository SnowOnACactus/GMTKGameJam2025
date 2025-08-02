extends Node2D
@onready var _emitter:CPUParticles2D = $CPUParticles2D2
@onready var _game_scene = get_tree().get_root().get_node("GameScene")

func _ready() -> void:
	if _game_scene.loop_number > 0:
		_emitter.emitting = true
