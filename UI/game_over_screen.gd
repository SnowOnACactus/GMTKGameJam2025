extends Control
@onready var try_again_button: Button = $GameOverBackground/GameOverVBox/TryAgainButton
@onready var quit_button: Button = $GameOverBackground/GameOverVBox/QuitButton
@onready var game_over_title: RichTextLabel = $GameOverBackground/GameOverVBox/GameOverTitle



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
