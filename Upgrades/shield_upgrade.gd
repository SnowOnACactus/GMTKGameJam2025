extends Upgrade

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title = "Shield!"
	explaination = "You get one free hit every other loop!"
	texture = preload("res://Upgrades/shield.png")

func on_upgrade(tree: SceneTree) -> Callable:
	return func() -> void:
		tree.get_root().get_node("GameScene/Runner").shield_upgrade = true
		tree.get_root().get_node("GameScene").shield.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
