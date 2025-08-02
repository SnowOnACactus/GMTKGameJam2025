extends Control
@onready var upgrade_1: MarginContainer = $UpgradeBackground/MarginContainer/UpgradeVBox/HBoxContainer/Upgrade1
@onready var upgrade_2: MarginContainer = $UpgradeBackground/MarginContainer/UpgradeVBox/HBoxContainer/Upgrade2

var upgrades: Array = [
	preload("res://Upgrades/shrink.gd"),
	preload("res://Upgrades/sword_upgrade.gd"),
	preload("res://Upgrades/wings.gd"),
	preload("res://Upgrades/shield_upgrade.gd"),
	preload("res://Upgrades/full_heal.gd"),
	preload("res://Upgrades/invulnerability_upgrade.gd"),
	preload("res://Upgrades/jump_upgrade.gd"),
	preload("res://Upgrades/speed_upgrade.gd"),
	preload("res://Upgrades/rotation_upgrade.gd"),
	preload("res://Upgrades/removal_upgrade.gd"),
]

func choose_upgrade(button) -> void:
	for connection_dict in button.get_button.pressed.get_connections():
		button.get_button.pressed.disconnect(connection_dict.callable)
	button.get_button.pressed.connect(func() -> void:
		hide()
		get_tree().paused = false
		)
	var upgrade = Upgrade.new()
	var script = upgrades.pick_random()
	upgrade.set_script(script)
	upgrade._ready()
	button.texture.texture = upgrade.texture
	button.title.text = upgrade.title
	button.explaination.text = upgrade.explaination
	button.get_button.pressed.connect(func() -> void:
		upgrade.on_upgrade(get_tree()).call()
		upgrades.erase(script)
	)

func refresh_upgrades() -> void:
	choose_upgrade(upgrade_1)
	choose_upgrade(upgrade_2)
	if upgrade_1.texture.texture == upgrade_2.texture.texture:
		choose_upgrade(upgrade_2)
	if upgrade_1.texture.texture == upgrade_2.texture.texture:
		choose_upgrade(upgrade_2)
	if upgrade_1.texture.texture == upgrade_2.texture.texture:
		choose_upgrade(upgrade_2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh_upgrades()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
