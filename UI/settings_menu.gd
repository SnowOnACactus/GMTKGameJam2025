extends Control

@onready var back_button: Button = $SettingsBackground/SettingsVBox/BackButton
@onready var _music_slider: HSlider = $SettingsBackground/SettingsVBox/MusicHBox/MusicSlider
@onready var _sounds_slider: HSlider = $SettingsBackground/SettingsVBox/SoundsHBox/SoundsSlider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_music_slider.value_changed.connect(func (value: float) -> void: AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value)))
	_sounds_slider.value_changed.connect(func (value: float) -> void: AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"), linear_to_db(value)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		pass

	
	
