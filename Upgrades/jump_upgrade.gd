extends Upgrade

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title = "Jump!"
	explaination = "You can jump! Higher!"
	texture = preload("res://Upgrades/parkour.png")

func on_upgrade(tree:SceneTree) -> Callable:
	return func() -> void:
		tree.get_root().get_node("GameScene/Runner").jump_velocity = -650.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
