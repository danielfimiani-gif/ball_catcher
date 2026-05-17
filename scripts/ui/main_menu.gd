extends Control

@export var game_scene: PackedScene

@onready var play_button: Button = $VBoxContainer/PlayButton
@onready var exit_button: Button = $VBoxContainer/ExitButton
@onready var highscore_label: Label = $VBoxContainer/HighScoreLabel

func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	play_button.mouse_entered.connect(_on_button_hover)
	exit_button.mouse_entered.connect(_on_button_hover)

	highscore_label.text = "HighScore : " + str(GameState.highscore)
	AudioManager._play_music("menu")
	pass

func _on_play_pressed() -> void:
	AudioManager._play_sfx("click")
	SceneManager.switch_scene("game")
	pass

func _on_exit_pressed() -> void:
	AudioManager._play_sfx("click")
	get_tree().quit()
	pass

func _on_button_hover() -> void:
	AudioManager._play_sfx("hover")
	pass