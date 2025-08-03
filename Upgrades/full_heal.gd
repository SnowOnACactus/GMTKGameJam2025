extends Upgrade

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title = "Full heal!"
	explaination = "You can get hit again!"
	texture = preload("res://Upgrades/hud_heartFull.png")

func on_upgrade(tree: SceneTree) -> Callable:
	return func() -> void:
		tree.get_root().get_node("GameScene/Runner").health = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
