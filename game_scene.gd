extends Node2D
@onready var _runner: CharacterBody2D = $Runner
@onready var _racetrack: Node2D = $Racetrack
const PICKUP = preload("res://Pickup/pickup.tscn")
@onready var _progress_gate: StaticBody2D = $ProgressGate
@onready var _loop_display: RichTextLabel = $CanvasLayer/LoopDisplay
@onready var _heart_1: Sprite2D = $Heart1
@onready var _heart_2: Sprite2D = $Heart2
@onready var _heart_3: Sprite2D = $Heart3
const _HEART_EMPTY = preload("res://Runners/hud_heartEmpty.png")
const _HEART_FULL = preload("res://Runners/hud_heartFull.png")

var loop_number := 0:
	set(num):
		loop_number = num
		_loop_display.text = ("Loop " + str(num))


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_runner.loop.connect(_on_loop)
	_runner.unlock.connect(func() -> void: _progress_gate.open = true)
	_runner.hurt_or_heal.connect(_on_hurt_or_heal)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_loop() -> void:
	spawn_pickup()
	_progress_gate.open = false
	loop_number += 1
	#TO-DO offer upgrade?

#probably a better way to do this...
func _on_hurt_or_heal(health: int) -> void:
	match health:
		0:
			_heart_1.texture = _HEART_EMPTY
			_heart_2.texture = _HEART_EMPTY
			_heart_3.texture = _HEART_EMPTY
		1:
			_heart_1.texture = _HEART_FULL
			_heart_2.texture = _HEART_EMPTY
			_heart_3.texture = _HEART_EMPTY
		2:
			_heart_1.texture = _HEART_FULL
			_heart_2.texture = _HEART_FULL
			_heart_3.texture = _HEART_EMPTY
		3:
			_heart_1.texture = _HEART_FULL
			_heart_2.texture = _HEART_FULL
			_heart_3.texture = _HEART_FULL

func spawn_pickup() -> void:
	var pickup = PICKUP.instantiate()
	add_child(pickup)
	pickup.global_position = Vector2(randf_range(100, get_viewport_rect().size.x - 100), 450)
