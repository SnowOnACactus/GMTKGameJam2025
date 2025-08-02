extends Control
@onready var resume_button: Button = $PauseBackground/PauseVBox/MarginContainer2/ResumeButton
@onready var options_button: Button = $PauseBackground/PauseVBox/MarginContainer3/OptionsButton
@onready var quit_button: Button = $PauseBackground/PauseVBox/MarginContainer4/QuitButton
@onready var restart_button: Button = $PauseBackground/PauseVBox/MarginContainer5/RestartButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
