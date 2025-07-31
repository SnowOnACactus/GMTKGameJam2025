extends CanvasLayer
@onready var settings_menu: Control = $SettingsMenu
@onready var pause_menu: Control = $PauseMenu



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu.hide()
	settings_menu.hide()
	pause_menu.resume_button.pressed.connect(func () -> void:
		get_tree().paused = false
		pause_menu.hide()
	)
	pause_menu.options_button.pressed.connect(func () -> void:
		pause_menu.hide()
		settings_menu.show()
	)
	pause_menu.quit_button.pressed.connect(func () -> void:
		get_tree().quit()
	)
	settings_menu.back_button.pressed.connect(func () -> void:
		settings_menu.hide()
		pause_menu.show()
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused == true:
			pause_menu.hide()
			settings_menu.hide()
			get_tree().paused = false
		else:
			get_tree().paused = true
			pause_menu.show()
