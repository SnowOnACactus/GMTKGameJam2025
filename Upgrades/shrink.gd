extends Upgrade

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title = "Shrink!"
	explaination = "You become smaller!"
	texture = preload("res://Upgrades/shrink.png")

func on_upgrade(tree:SceneTree) -> Callable:
	return func() -> void:
		tree.get_root().get_node("GameScene/Runner").scale.x *= 0.5
		tree.get_root().get_node("GameScene/Runner").scale.y *= 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
