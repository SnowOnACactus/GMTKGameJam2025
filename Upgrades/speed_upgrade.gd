extends Upgrade

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title = "Speedy!"
	explaination = "Gotta go fast!"
	texture = preload("res://Upgrades/running.png")

func on_upgrade(tree: SceneTree) -> Callable:
	return func() -> void:
		tree.get_root().get_node("GameScene/Runner").speed = 450.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
