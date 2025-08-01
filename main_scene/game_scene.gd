extends Node2D
@onready var _runner: CharacterBody2D = $Runner
const PICKUP = preload("res://Pickup/pickup.tscn")
@onready var _progress_gate: StaticBody2D = $Boundries/ProgressGate
@onready var _loop_display: RichTextLabel = $CanvasLayer/LoopDisplay
@onready var _heart_1: Sprite2D = $Heart1
@onready var _heart_2: Sprite2D = $Heart2
@onready var _heart_3: Sprite2D = $Heart3
const _HEART_EMPTY = preload("res://Runners/hud_heartEmpty.png")
const _HEART_FULL = preload("res://Runners/hud_heartFull.png")
@onready var menu_controller: CanvasLayer = $MenuController
@onready var _loop_timer: Timer = $LoopTimer
@onready var _time_left: RichTextLabel = $LoopTimer/TimeLeft
@onready var taunt: RichTextLabel = $CanvasLayer/Taunt



var tutorial_done := false

var loop_number := 0:
	set(num):
		loop_number = num
		_loop_display.text = ("Loop " + str(num))


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_runner.loop.connect(_on_loop)
	_runner.unlock.connect(func() -> void: _progress_gate.open = true)
	_runner.hurt_or_heal.connect(_on_hurt_or_heal)
	_runner.game_over.connect(func() -> void: game_over("die"))
	_runner.overlap.connect(func() -> void:
		taunt.text = "[color=red]Overlapping is not allowed. Try again![/color]"
		await get_tree().create_timer(2.0).timeout
		taunt.text = "Can you make it through 20 loops?"
	)
	_loop_timer.timeout.connect(func() -> void: game_over("time"))

func game_over(reason) -> void:
	_loop_timer.stop()
	if reason == "time":
		_runner.die()
		menu_controller.game_over_screen.game_over_title.text = "You ran out of time"
	if reason == "die":
		menu_controller.game_over_screen.game_over_title.text = "You died"
	await get_tree().create_timer(2.5).timeout
	menu_controller.game_over_screen.show()
	get_tree().paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_time_left.text = "Time left: " + (str(floori(_loop_timer.get_time_left()))) + "s"

func _on_loop() -> void:
	spawn_pickup()
	_progress_gate.open = false
	loop_number += 1
	var new_time = _loop_timer.time_left + 10
	_loop_timer.wait_time = new_time
	_loop_timer.start()
	if loop_number == 1:
		taunt.text = "Collect the item to open the door"
	if loop_number == 2:
		taunt.text = "Watch your health and remaining time!"
		tutorial_done = true
	if loop_number == 3:
		taunt.text = "Can you make it through 20 loops?"
	if (floor(loop_number/5.0) == loop_number/5.0):
		menu_controller.upgrade_menu.show()
		get_tree().paused = true

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
	pickup.global_position = Vector2(randf_range(100, get_viewport_rect().size.x/2), 450)
