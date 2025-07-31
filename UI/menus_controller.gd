extends CanvasLayer
@onready var settings_menu: Control = $SettingsMenu
@onready var pause_menu: Control = $PauseMenu
@onready var upgrade_menu: Control = $UpgradeMenu



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu.hide()
	settings_menu.hide()
	upgrade_menu.hide()
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
	#TO-DO - make these upgrades do something
	upgrade_menu.upgrade_1.pressed.connect(func() -> void:
		upgrade_menu.hide()
		get_tree().paused = false
	)
	upgrade_menu.upgrade_2.pressed.connect(func() -> void:
		upgrade_menu.hide()
		get_tree().paused = false
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
