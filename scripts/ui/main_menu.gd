extends Control

@export var game_scene: PackedScene

@onready var title_label: Label = $VBoxContainer/Title
@onready var play_button: Button = $VBoxContainer/PlayButton
@onready var options_button: Button = $VBoxContainer/OptionsButton
@onready var exit_button: Button = $VBoxContainer/ExitButton
@onready var highscore_label: Label = $VBoxContainer/HighScoreLabel

func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	options_button.pressed.connect(_on_options_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	play_button.mouse_entered.connect(_on_button_hover)
	options_button.mouse_entered.connect(_on_button_hover)
	exit_button.mouse_entered.connect(_on_button_hover)

	highscore_label.text = "HighScore : " + str(GameState.highscore)
	AudioManager._play_music("menu")

	if OS.has_feature("web"):
		exit_button.visible = false

	_animate_entrance()
	pass

func _on_play_pressed() -> void:
	AudioManager._play_sfx("click")
	SceneManager.switch_scene("game")
	pass

func _on_options_pressed() -> void:
	AudioManager._play_sfx("click")
	SceneManager.switch_scene("options")
	pass

func _on_exit_pressed() -> void:
	AudioManager._play_sfx("click")
	get_tree().quit()
	pass

func _on_button_hover() -> void:
	AudioManager._play_sfx("hover")
	pass

func _animate_entrance() -> void:
	title_label.pivot_offset = title_label.size / 2.0
	title_label.scale = Vector2(0.3, 0.3)
	title_label.modulate.a = 0.0
	play_button.modulate.a = 0.0
	exit_button.modulate.a = 0.0
	options_button.modulate.a = 0.0
	highscore_label.modulate.a = 0.0

	var title_tween := create_tween().set_parallel()
	var scale_anim := title_tween.tween_property(title_label, "scale", Vector2.ONE, 0.6)
	scale_anim.set_trans(Tween.TRANS_BACK)
	scale_anim.set_ease(Tween.EASE_OUT)
	title_tween.tween_property(title_label, "modulate:a", 1.0, 0.4)

	var stagger := create_tween()
	stagger.tween_interval(0.35)
	stagger.tween_property(play_button, "modulate:a", 1.0, 0.3)

	stagger.tween_interval(0.18)
	stagger.tween_property(options_button, "modulate:a", 1.0, 0.3)

	stagger.tween_interval(0.28)
	stagger.tween_property(exit_button, "modulate:a", 1.0, 0.3)

	stagger.tween_interval(0.1)
	stagger.tween_property(highscore_label, "modulate:a", 1.0, 0.3)
	pass