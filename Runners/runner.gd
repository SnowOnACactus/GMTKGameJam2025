extends CharacterBody2D
signal loop
signal unlock
signal hurt_or_heal
signal game_over

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _pickup_radius: Area2D = $PickupRadius
@onready var _thought_bubble: Sprite2D = $ThoughtBubble
@onready var _item_thought: Sprite2D = $ThoughtBubble/ItemThought
@onready var _weapon: Area2D = $Weapon
@onready var _sword: Sprite2D = $Weapon/Sword
@onready var _collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var _placement_confirmation: Sprite2D = $PlacementConfirmation

@export var health := 3:
	set(num):
		if num <= 0:
			game_over.emit()
			die()
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
var _faced_right := true:
	set(bool):
		_faced_right = bool
		_sprite.flip_h = bool

const SPEED = 300.0
const JUMP_VELOCITY = -600.0


func _ready() -> void:
	_pickup_radius.area_entered.connect(
		func(body) -> void: 
			if body is Pickup: 
				_on_pickup(body)
			if body.get_parent() is Mob:
				health -= 1
	)

func _on_pickup(body) -> void:
	has_item = true
	_thought_bubble.visible = true
	held_item = body.pick_random_item()
	_item_thought.texture = held_item.texture
	body.queue_free()

func _on_attack(direction) -> void:
	#show sword
	_weapon.visible = true
	var tween = create_tween()
	#swing sword
	if direction < 0:
		tween.tween_property(_weapon, "rotation_degrees", -150.0, 0.1)
	else:
		tween.tween_property(_weapon, "rotation_degrees", 100.0, 0.1)
	#hide and reset sword at the end of animation
	tween.finished.connect(
		func() -> void:
			_weapon.visible = false
			_weapon.rotation = 0
	)

func _on_use_press() -> void:
	if !_hovering_item:
		_thought_bubble.visible = false
		_hovering_item = held_item.scene.instantiate()
		held_item = {}
		_hovering_item.position = Vector2(_thought_bubble.position.x + 200, _thought_bubble.position.y)
		add_child(_hovering_item)
		_hovering_item.set_physics_process(false)
		_placement_confirmation.visible = true

func _on_use_release() -> void:
	# Let the item go in the scene world where it was
	if _hovering_item:
		if !_hovering_item.hitbox.has_overlapping_areas():
			if _hovering_item is Mob:
				_hovering_item.starting_position = _hovering_item.global_position
			_hovering_item.reparent(get_tree().get_root().get_node("GameScene"), true)
			_hovering_item.set_physics_process(true)
			_hovering_item = null
			has_item = false
			_placement_confirmation.visible = false
			unlock.emit()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#Run from right side to left
	if global_position.x > get_viewport_rect().size.x + 50:
		global_position.x -= get_viewport_rect().size.x + 90
		loop.emit()
	
	#Run from left to right - do we want this? Commenting out as it currently can trigger loops
	#if global_position.x < -50:
	#	global_position.x += get_viewport_rect().size.x + 90
	
	#display placement errors:
	if _hovering_item and _hovering_item.hitbox.has_overlapping_areas():
		_placement_confirmation.texture = preload("res://Runners/icon_cross.png")
	if _hovering_item and !_hovering_item.hitbox.has_overlapping_areas():
		_placement_confirmation.texture = preload("res://Runners/icon_checkmark.png")
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if _is_crouched:
			_is_crouched = false
		_sprite.play("jump")
	
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
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	if Input.is_action_just_pressed("attack"):
		_on_attack(direction)
		
	if velocity.y > 0:
		_sprite.play("fall")
		
	if direction:
		if direction < 0: 
			_faced_right = true
		if direction > 0:
			_faced_right = false
		if velocity.y == 0:
			_sprite.play("walk")
		velocity.x = direction * SPEED
	else:
		if velocity == Vector2.ZERO and !_is_crouched:
			_sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func die() -> void:
	#TO-DO - play death sound
	_sprite.play("die")
	set_physics_process(false)
