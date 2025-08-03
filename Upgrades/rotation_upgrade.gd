extends Upgrade

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title = "Rotate!"
	explaination = "The objects you hold rotate!"
	texture = preload("res://Upgrades/rotate.png")

func on_upgrade(tree:SceneTree) -> Callable:
	return func() -> void:
		tree.get_root().get_node("GameScene/Runner").rotation_upgrade = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
