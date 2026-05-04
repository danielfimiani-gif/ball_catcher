extends Node

signal score_changed(new_score: int)
signal lives_changed(new_lives: int)

enum Result {
	VICTORY,
	DEFEAT
}

const STARTING_LIVES: int = 3
const TARGET_SCORE: int = 500

var last_result: Result = Result.DEFEAT

var score: int = 0:
	set(value):
		score = max(0, value)
		score_changed.emit(score)
		if score >= TARGET_SCORE:
			last_result = Result.VICTORY
			_on_game_ended()

var lives: int = STARTING_LIVES:
	set(value):
		lives = max(0, value)
		lives_changed.emit(lives)
		if lives <= 0:
			last_result = Result.DEFEAT
			_on_game_ended()

func reset() -> void:
	score = 0
	lives = STARTING_LIVES
	pass

func _on_game_ended() -> void:
	SceneManager.switch_scene("end_game")
	pass