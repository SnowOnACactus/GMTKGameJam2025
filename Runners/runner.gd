class_name Player extends CharacterBody2D
signal loop
signal unlock
signal hurt_or_heal
signal game_over
signal overlap
signal shield_broken

var speed = 300.0
var jump_velocity = -500.0
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _pickup_radius: Area2D = $PickupRadius
@onready var _thought_bubble: Sprite2D = $ThoughtBubble
@onready var _item_thought: Sprite2D = $ThoughtBubble/ItemThought
@onready var _weapon: Area2D = $Weapon
@onready var _placement_confirmation: Sprite2D = $PlacementConfirmation
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var _item_spawn_poof: CPUParticles2D = $ItemSpawnPoof



# This dictionary of dictionaries allows us to label a song and call for it to play("key") 
# at a specific time just by using the key - please keep to this format
var sounds := {
	"thought": {"audio": preload("res://Runners/543183__garuda1982__plop-sound-effect.wav"), "start_time": 0.3},
	"jump": {"audio": preload("res://Runners/456374__felixyadomi__hop8.wav"), "start_time": 0.0},
	"pain": {"audio": preload("res://Runners/434462__dersuperanton__getting-hit-hugh.wav"), "start_time": 0.1},
	"game_over": {"audio": preload("res://Runners/382310__mountain_man__game-over-arcade.wav"), "start_time": 0.0},
	"boing": {"audio": preload("res://Runners/540790__magnuswaker__boing-2.wav"), "start_time": 0.0}
}

var direction := 0.0
var stuck := false
var invulnerable_frames := false:
	set(bool):
		if bool == true:
			invulnerable_frames = true
			await get_tree().create_timer(invulnerable_upgrade).timeout
			invulnerable_frames = false
		else:
			invulnerable_frames = false
var sword_upgrade := false
var wings_upgrade := false
var _double_jumped := false
var rotation_upgrade := false
var invulnerable_upgrade := 1
var shielded := false:
	set(bool):
		if bool == false: shield_broken.emit()
		shielded = bool
var removal_upgrade = false
var shield_upgrade := false:
	set(bool):
		if bool == true: shielded = true
		shield_upgrade = bool

@export var health := 3:
	set(num):
		if num == 0:
			game_over.emit()
			die()
		if num > 0 and num < health:
			invulnerable_frames = true
			_sprite.play("ouch")
			play("pain")
		health = num
		hurt_or_heal.emit(health)

var _hovering_item: Node = null
var held_item: Dictionary = {}
var has_item := false
var _is_crouched := false:
	set(bool):
		_is_crouched = bool
		if bool: 
			_sprite.play("crouch")
			if _hovering_item:
				_hovering_item.position.y += 30
		if !bool and _hovering_item and is_on_floor():
			_hovering_item.position.y -= 30
			
		_sprite.flip_h = !_sprite.flip_h
var faced_right := true:
	set(bool):
		if _hovering_item and bool:
			_hovering_item.position.x = _thought_bubble.position.x - 200
		if _hovering_item and !bool:
			_hovering_item.position.x = _thought_bubble.position.x + 200
		faced_right = bool
		_sprite.flip_h = bool



func _ready() -> void:
	_pickup_radius.area_entered.connect(
		func(body) -> void: 
			if body is Pickup: 
				_on_pickup(body)
			if (body.get_parent() is Mob or body.get_parent() is Hurt) and !invulnerable_frames:
				if removal_upgrade:
					body.get_parent().queue_free()
					removal_upgrade = false
				else:
					if shielded:
						shielded = false
						invulnerable_frames = true
					else:
						health -= 1
			if body.get_parent() is Bouncy:
				if removal_upgrade:
					body.get_parent().queue_free()
					removal_upgrade = false
				else:
					velocity.y = -700
					play("boing")
			if body.get_parent() is Sticky and (body.get_parent().get_parent() != self):
				if removal_upgrade:
					body.get_parent().queue_free()
					removal_upgrade = false
				else:
					velocity = Vector2.ZERO
					stuck = true
					_pickup_radius.area_exited.connect(func(area) -> void:
						if area == body:
							stuck = false
					, CONNECT_ONE_SHOT)
			if body.get_parent() is Slippery and (body.get_parent().get_parent() != self):
				if removal_upgrade:
					body.get_parent().queue_free()
					removal_upgrade = false
	)

func _on_pickup(body) -> void:
	has_item = true
	_thought_bubble.visible = true
	held_item = body.pick_random_item()
	_item_thought.texture = held_item.texture
	body.queue_free()
	if !get_parent().tutorial_done:
		get_parent().taunt.text = "Hold E to preview placement"

func _on_attack(direction) -> void:
	#show sword
	_weapon.visible = true		
	_weapon.monitorable = true
	_weapon.monitoring = true
	var tween = create_tween()
	#swing sword
	if direction < 0:
		tween.tween_property(_weapon, "rotation_degrees", -150.0, 0.1)
	else:
		tween.tween_property(_weapon, "rotation_degrees", 130.0, 0.1)
	#hide and reset sword at the end of animation
	tween.finished.connect(
		func() -> void:
			_weapon.visible = false
			_weapon.rotation = 0
			_weapon.monitorable = false
			_weapon.monitoring = false
	)

func _on_use_press() -> void:
	if !_hovering_item:
		play("thought")
		_thought_bubble.visible = false
		_hovering_item = held_item.scene.instantiate()
		held_item = {}
		if faced_right:
			_hovering_item.position = Vector2(_thought_bubble.position.x - 200, _thought_bubble.position.y)
		if !faced_right:
			_hovering_item.position = Vector2(_thought_bubble.position.x + 200, _thought_bubble.position.y)
		_item_spawn_poof.position = _hovering_item.position
		_item_spawn_poof.emitting = true
		add_child(_hovering_item)
		_hovering_item.collision_layer = 0
		_hovering_item.collision_mask = 0
		_hovering_item.hitbox.monitorable = false
		_hovering_item.set_physics_process(false)
		_placement_confirmation.visible = true
		if !get_parent().tutorial_done:
			get_parent().taunt.text = "Release E to place the obstacle in a free space"

func _on_use_release() -> void:
	# Let the item go in the scene world where it was
	if _hovering_item:
		if !_hovering_item.hitbox.has_overlapping_areas():
			_hovering_item.reparent(get_tree().get_root().get_node("GameScene"), true)
			if _hovering_item is Mob:
				_hovering_item.starting_position = _hovering_item.global_position * 2
			_hovering_item.set_physics_process(true)
			_hovering_item.collision_layer = 1
			_hovering_item.collision_mask = 1
			_hovering_item.hitbox.monitorable = true
			_hovering_item = null
			has_item = false
			_placement_confirmation.visible = false
			unlock.emit()
		else:
			overlap.emit()

func play (sound: String) -> void:
	audio_stream_player_2d.stream = sounds[sound].audio
	audio_stream_player_2d.play(sounds[sound].start_time)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and !stuck:
		velocity += get_gravity() * delta
	
	#Run from right side to left
	if global_position.x > get_viewport_rect().size.x + 25:
		global_position.x -= get_viewport_rect().size.x + 40
		loop.emit()
	
	#Run from left to right - do we want this? Commenting out as it currently can trigger loops
	#if global_position.x < -50:
	#	global_position.x += get_viewport_rect().size.x + 90
	
	if rotation_upgrade and _hovering_item:
		_hovering_item.rotation += delta
	
	#display placement errors:
	if _hovering_item and _hovering_item.hitbox.has_overlapping_areas():
		_placement_confirmation.texture = preload("res://Runners/icon_cross.png")
	if _hovering_item and !_hovering_item.hitbox.has_overlapping_areas():
		_placement_confirmation.texture = preload("res://Runners/icon_checkmark.png")
	

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or (wings_upgrade and !_double_jumped)):
		velocity.y = jump_velocity
		if wings_upgrade and !is_on_floor():
			_double_jumped = true
			_sprite.play("fly")
		if _is_crouched:
			_is_crouched = false
		if !wings_upgrade or is_on_floor():
			_sprite.play("jump")
		play("jump")
	if is_on_floor() and wings_upgrade:
		_double_jumped = false
	# stop jump when released
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = 0
	if Input.is_action_just_pressed("move_down") and is_on_floor():
		_is_crouched = true

	if Input.is_action_just_released("move_down") and is_on_floor():
		_is_crouched = false

	# Handle use
	if Input.is_action_just_pressed("use"):
		if has_item: _on_use_press()
	
	# Handle use release
	if Input.is_action_just_released("use"):
		_on_use_release()
	# Get the input direction and handle the movement/deceleration.
	if !_check_for_slip():
		direction = Input.get_axis("move_left", "move_right")
	if _check_for_slip():
		if faced_right:
			direction = -1.0
		if !faced_right:
			direction = 1.0
	if Input.is_action_just_pressed("attack"):
		if sword_upgrade:
			_on_attack(direction)
		
	if velocity.y > 0:
		_sprite.play("fall")
		
	if direction:
		if direction < 0: 
			faced_right = true
		if direction > 0:
			faced_right = false
		if velocity.y == 0:
			_sprite.play("walk")
		velocity.x = direction * speed
	else:
		if velocity == Vector2.ZERO and !_is_crouched:
			_sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()

func _check_for_slip() -> bool:
	var slip = false
	for child in _pickup_radius.get_overlapping_areas():
		if child.get_parent() is Slippery:
			slip = true
	return slip

func die() -> void:
	set_physics_process(false)
	play("game_over")
	_sprite.play("die")
