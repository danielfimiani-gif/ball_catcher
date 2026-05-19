extends Control

@onready var master_slider: HSlider = $VBoxContainer/AudioSection/Master/HSlider
@onready var music_slider: HSlider = $VBoxContainer/AudioSection/Music/HSlider
@onready var sfx_slider: HSlider = $VBoxContainer/AudioSection/SFX/HSlider
@onready var back_button: Button = $VBoxContainer/BackButton

const MASTER_BUS: int = 0
const MUSIC_BUS: int = 1
const SFX_BUS: int = 2

func _ready() -> void:
    master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(MASTER_BUS))
    music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(MUSIC_BUS))
    sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(SFX_BUS))

    master_slider.value_changed.connect(_on_master_changed)
    music_slider.value_changed.connect(_on_music_changed)
    sfx_slider.value_changed.connect(_on_sfx_changed)

    back_button.pressed.connect(_on_back_pressed)
    back_button.mouse_entered.connect(_on_button_hover)
    back_button.grab_focus()
    pass

func _on_master_changed(value: float) -> void:
    AudioServer.set_bus_volume_db(MASTER_BUS, linear_to_db(value))
    pass

func _on_music_changed(value: float) -> void:
    AudioServer.set_bus_volume_db(MUSIC_BUS, linear_to_db(value))
    pass

func _on_sfx_changed(value: float) -> void:
    AudioServer.set_bus_volume_db(SFX_BUS, linear_to_db(value))
    pass

func _on_back_pressed() -> void:
    AudioManager._play_sfx("click")
    AudioManager._save_settings()
    SceneManager.switch_scene("main_menu")
    pass

func _on_button_hover() -> void:
    AudioManager._play_sfx("hover")
    pass