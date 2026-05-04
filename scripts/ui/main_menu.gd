extends Control

@export var game_scene: PackedScene

@onready var play_button: Button = $VBoxContainer/PlayButton
@onready var exit_button: Button = $VBoxContainer/ExitButton

func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	pass

func _on_play_pressed() -> void:
	SceneManager.switch_scene("game")
	pass

func _on_exit_pressed() -> void:
	get_tree().quit()
	pass
