extends Control
@onready var _start_button: Button = $StartButton

func _ready() -> void:
	_start_button.pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://main_scene/game_scene.tscn")
