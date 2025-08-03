class_name GameScene extends Node2D
@onready var _runner: CharacterBody2D = $Runner
const PICKUP = preload("res://Pickup/pickup.tscn")
@onready var _progress_gate: StaticBody2D = $ProgressGate
@onready var _loop_display: RichTextLabel = $CanvasLayer/LoopDisplay
@onready var _heart_1: Sprite2D = $CanvasLayer/HealthDisplay/Heart1
@onready var _heart_2: Sprite2D = $CanvasLayer/HealthDisplay/Heart2
@onready var _heart_3: Sprite2D = $CanvasLayer/HealthDisplay/Heart3
const _HEART_EMPTY = preload("res://Runners/hud_heartEmpty.png")
const _HEART_FULL = preload("res://Runners/hud_heartFull.png")
@onready var menu_controller: CanvasLayer = $MenuController
@onready var _loop_timer: Timer = $CanvasLayer/LoopTimer
@onready var _time_left: RichTextLabel = $CanvasLayer/LoopTimer/TimeLeft
@onready var taunt: RichTextLabel = $CanvasLayer/Taunt
@onready var camera_2d: Camera2D = $Camera2D
@onready var shield: Sprite2D = $CanvasLayer/HealthDisplay/Shield
@onready var _audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var alarm: AudioStreamPlayer2D = $"Alarm sound effect"
@onready var _floor: StaticBody2D = $Floor

var _alarm_not_sounded = true
@onready var H3Pop = $CanvasLayer/HealthDisplay/Heart3/Heart3Pop
@onready var H2Pop = $CanvasLayer/HealthDisplay/Heart2/Heart2Pop
@onready var H1Pop = $CanvasLayer/HealthDisplay/Heart1/Heart1Pop


var tutorial_done := false

var loop_number := 0:
	set(num):
		loop_number = num
		_loop_display.text = ("Loop " + str(num))
var out_of_bounds := false

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
	_runner.shield_broken.connect(shield.hide)
	_loop_timer.timeout.connect(func() -> void: game_over("time"))
	_audio_stream_player_2d.finished.connect(_audio_stream_player_2d.play)
	#var tween = create_tween()
	#tween.tween_property(camera_2d, "zoom", Vector2(0.5,0.5), 10)
	#var tween2 = create_tween()
	#tween2.tween_property(camera_2d, "position", Vector2(get_viewport_rect().size.x/4, get_viewport_rect().size.y/4), 10)
	

func game_over(reason) -> void:
	_loop_timer.paused = true
	if reason == "time":
		_runner.die()
		menu_controller.game_over_screen.game_over_title.text = "You ran out of time"
	if reason == "die":
		menu_controller.game_over_screen.game_over_title.text = "You died"
	if reason == "out of bounds":
		await get_tree().create_timer(0.3).timeout
		_runner.die()
		menu_controller.game_over_screen.game_over_title.text = "You fell forever"
	await get_tree().create_timer(2.5).timeout
	menu_controller.game_over_screen.show()
	get_tree().paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_time_left.text = "Time left: " + (str(floori(_loop_timer.get_time_left()))) + "s"
	#5sec alert sound and red text
	if (floori(_loop_timer.get_time_left())) <=5:
		if _alarm_not_sounded and (floori(_loop_timer.get_time_left())) > 0:
			_alarm_not_sounded = false
			alarm.play()
		_time_left.add_theme_color_override("default_color", Color(1,0,0))
	else:
		#reset text to black
		_time_left.add_theme_color_override("default_color", Color(0,0,0))
	if !out_of_bounds and (_runner.position.y > _floor.position.y):
		out_of_bounds = true
		game_over("out of bounds")

func _on_loop() -> void:
	spawn_pickup()
	_alarm_not_sounded = true
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
	if loop_number == 5:
		taunt.text = "The ground looks unstable... careful you don't fall through"
	if loop_number == 10:
		taunt.text = "Did you know you can crouch to place objects lower?"
	if loop_number == 10:
		taunt.text = "Did you know flies die to spikes?"
	if loop_number == 20:
		taunt.text = "You did 20 loops! Thank you for playing"
	if (floor(loop_number/5.0) == loop_number/5.0):
		menu_controller.upgrade_menu.show()
		menu_controller.upgrade_menu.refresh_upgrades()
		get_tree().paused = true
	if _runner.shield_upgrade and (floor(loop_number/2.0) == loop_number/2.0):
		_runner.shielded = true
		shield.show()

#probably a better way to do this...
func _on_hurt_or_heal(health: int) -> void:
	match health:
		0:
			_heart_1.texture = _HEART_EMPTY
			_heart_2.texture = _HEART_EMPTY
			_heart_3.texture = _HEART_EMPTY
			H1Pop.emitting = true
		1:
			_heart_1.texture = _HEART_FULL
			_heart_2.texture = _HEART_EMPTY
			_heart_3.texture = _HEART_EMPTY
			H2Pop.emitting = true
		2:
			_heart_1.texture = _HEART_FULL
			_heart_2.texture = _HEART_FULL
			_heart_3.texture = _HEART_EMPTY
			H3Pop.emitting = true
			
		3:
			_heart_1.texture = _HEART_FULL
			_heart_2.texture = _HEART_FULL
			_heart_3.texture = _HEART_FULL

func spawn_pickup() -> void:
	var pickup = PICKUP.instantiate()
	add_child(pickup)
	pickup.global_position = Vector2(randf_range(100, get_viewport_rect().size.x/2), 450)
