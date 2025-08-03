extends Control
@onready var _start_button: Button = $StartButton
@onready var _credits_button: Button = $CreditsButton
@onready var _credits_screen: Control = $CreditsScreen

func _ready() -> void:
	_start_button.pressed.connect(_on_start_button_pressed)
	_credits_button.pressed.connect(_credits_screen.show)

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://main_scene/game_scene.tscn")
