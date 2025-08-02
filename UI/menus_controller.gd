extends CanvasLayer
@onready var settings_menu: Control = $SettingsMenu
@onready var pause_menu: Control = $PauseMenu
@onready var upgrade_menu: Control = $UpgradeMenu
@onready var game_over_screen: Control = $GameOverScreen

# Connecting all the menu's buttons.
func _ready() -> void:
	#upgrade_menu.show()
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
	pause_menu.restart_button.pressed.connect(func () -> void:
		get_tree().paused = false
		get_tree().reload_current_scene()
	)
	settings_menu.back_button.pressed.connect(func () -> void:
		settings_menu.hide()
		pause_menu.show()
	)
	#TO-DO - make these upgrades do something
	upgrade_menu.upgrade_1.get_button.pressed.connect(func() -> void:
		upgrade_menu.hide()
		get_tree().paused = false
	)
	upgrade_menu.upgrade_2.get_button.pressed.connect(func() -> void:
		upgrade_menu.hide()
		get_tree().paused = false
	)
	game_over_screen.try_again_button.pressed.connect(func () -> void:
		get_tree().paused = false
		get_tree().reload_current_scene()
	)
	game_over_screen.quit_button.pressed.connect(func () -> void:
		get_tree().quit()
	)


# Listen for pause
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and game_over_screen.visible == false and upgrade_menu.visible == false:
		if get_tree().paused == true:
			pause_menu.hide()
			settings_menu.hide()
			get_tree().paused = false
		else:
			get_tree().paused = true
			pause_menu.show()
