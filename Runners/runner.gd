extends CharacterBody2D
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _pickup_radius: Area2D = $PickupRadius
@onready var _thought_bubble: Sprite2D = $ThoughtBubble
@onready var _item_thought: Sprite2D = $ThoughtBubble/ItemThought
@onready var _weapon: Area2D = $Weapon
@onready var _sword: Sprite2D = $Weapon/Sword
const PLATFORM = preload("res://Obstacles/platform.tscn")
var _hovering_item: Node = null

var has_item = false:
	set(bool):
		_thought_bubble.visible = bool
		has_item = bool

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
signal loop
signal unlock

func _ready() -> void:
	_pickup_radius.area_entered.connect(
		func(body) -> void: 
			if body is Pickup: 
				_on_pickup(body)
	)

func _on_pickup(body) -> void:
	#TO-DO: generate obstacle pickup
	has_item = true
	body.queue_free()

func _on_attack(direction) -> void:
	#show sword
	_weapon.monitoring = true
	_sword.visible = true
	var tween = create_tween()
	#swing sword
	if direction < 0:
		tween.tween_property(_weapon, "rotation_degrees", -150.0, 0.1)
	else:
		tween.tween_property(_weapon, "rotation_degrees", 100.0, 0.1)
	#hide and reset sword at the end of animation
	tween.finished.connect(
		func() -> void:
			_weapon.monitoring = false
			_sword.visible = false
			_weapon.rotation = 0
	)

func _on_use_press() -> void:
	_thought_bubble.visible = false
	_hovering_item = PLATFORM.instantiate()
	_hovering_item.position = Vector2(_thought_bubble.position.x + 200, _thought_bubble.position.y)
	add_child(_hovering_item)
	

func _on_use_release() -> void:
	# Let the item go in the scene world where it was
	if _hovering_item:
		_hovering_item.reparent(get_tree().get_root().get_node("GameScene"), true)
		unlock.emit()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#Run from right side to left
	if global_position.x > get_viewport_rect().size.x + 50:
		global_position.x -= get_viewport_rect().size.x + 90
		loop.emit()
	
	#Run from left to right - do we want this?
	if global_position.x < -50:
		global_position.x += get_viewport_rect().size.x + 90
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		_sprite.play("jump")
	
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
			_sprite.flip_h = true
		else:
			_sprite.flip_h = false
		if velocity.y == 0:
			_sprite.play("walk")
		velocity.x = direction * SPEED
	else:
		if velocity == Vector2.ZERO:
			_sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
