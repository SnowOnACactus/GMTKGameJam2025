extends Control
@onready var upgrade_1: MarginContainer = $UpgradeBackground/MarginContainer/UpgradeVBox/HBoxContainer/Upgrade1
@onready var upgrade_2: MarginContainer = $UpgradeBackground/MarginContainer/UpgradeVBox/HBoxContainer/Upgrade2

var upgrades: Array = [
	preload("res://Upgrades/shrink.gd"),
	preload("res://Upgrades/sword_upgrade.gd")
]

func choose_upgrade(button) -> void:
	var upgrade = Upgrade.new()
	upgrade.set_script(upgrades.pick_random())
	upgrade._ready()
	button.texture.texture = upgrade.texture
	button.title.text = upgrade.title
	button.explaination.text = upgrade.explaination
	button.get_button.pressed.connect(upgrade.on_upgrade(get_tree()))


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	choose_upgrade(upgrade_1)
	choose_upgrade(upgrade_2)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
