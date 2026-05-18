extends Node

const SAVE_PATH: String = "user://savegame.cfg"
const SAVE_SECTION: String = "stats"
const SAVE_KEY_HIGHSCORE: String = "highscore"

signal score_changed(new_score: int)
signal lives_changed(new_lives: int)
signal highscore_changed(new_highscore: int)

const STARTING_LIVES: int = 3

var was_new_highscore: bool = false

var score: int = 0:
	set(value):
		score = max(0, value)
		score_changed.emit(score)

var lives: int = STARTING_LIVES:
	set(value):
		lives = max(0, value)
		lives_changed.emit(lives)
		if lives <= 0:
			_on_game_ended()

var highscore: int = 0:
	set(value):
		highscore = max(0, value)
		highscore_changed.emit(highscore)

func _ready() -> void:
	_load_highscore()
	pass

func reset() -> void:
	score = 0
	lives = STARTING_LIVES
	was_new_highscore = false
	pass

func _on_game_ended() -> void:
	was_new_highscore = score > highscore
	if was_new_highscore:
		highscore = score
		_save_highscore()

	Events.screen_shake_requested.emit(0.7)

	await get_tree().create_timer(0.4).timeout
	SceneManager.switch_scene("end_game")
	pass

func _load_highscore() -> void:
	var config := ConfigFile.new()
	var err := config.load(SAVE_PATH)
	if err == OK:
		highscore = config.get_value(SAVE_SECTION, SAVE_KEY_HIGHSCORE, 0)
	pass

func _save_highscore() -> void:
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value(SAVE_SECTION, SAVE_KEY_HIGHSCORE, highscore)
	config.save(SAVE_PATH)
	pass
