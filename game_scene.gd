extends Node2D
@onready var _runner: CharacterBody2D = $Runner
@onready var _racetrack: Node2D = $Racetrack
const PICKUP = preload("res://Pickup/pickup.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_runner.loop.connect(_on_loop)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_loop() -> void:
	spawn_pickup()

func spawn_pickup() -> void:
	var pickup = PICKUP.instantiate()
	add_child(pickup)
	pickup.global_position = Vector2(randf_range(100, get_viewport_rect().size.x - 100), 450)
