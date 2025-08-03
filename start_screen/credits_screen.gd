extends Control
@onready var _button: Button = $CreditsBackground/MarginContainer/CredistsVBox/MarginContainer2/Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_button.pressed.connect(hide)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
