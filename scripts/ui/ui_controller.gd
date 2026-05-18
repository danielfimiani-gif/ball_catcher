extends CanvasLayer

@onready var score_label: Label = $ScoreContainer/ScoreLabel
@onready var hearts_container: HBoxContainer = $HeartsContainer
@onready var hook_icon: TextureRect = $HookIndicator/HookIcon
@onready var cooldown_bar: ProgressBar = $HookIndicator/ProgressBar
@onready var hearts: Array[TextureRect] = [
	$HeartsContainer/Heart1,
	$HeartsContainer/Heart2,
	$HeartsContainer/Heart3,
]

var previous_lives: int = -1
var shake_tween: Tween
var score_tween: Tween

func _ready() -> void:
	GameState.score_changed.connect(_on_score_changed)
	GameState.lives_changed.connect(_on_lives_changed)

	_on_lives_changed(GameState.lives)
	_on_score_changed(GameState.score)

	Events.hook_cooldown_changed.connect(_on_hook_cooldown_changed)
	cooldown_bar.value = 100
	hook_icon.modulate = Color.WHITE
	pass

func _on_score_changed(new_value: int) -> void:
	score_label.text = "Score : " + str(new_value)
	_pop_label(score_label)
	pass

func _on_lives_changed(new_value: int) -> void:
	if previous_lives < 0:
		_show_all_hearts()
	elif new_value < previous_lives:
		for i in range(new_value, previous_lives):
			if i < hearts.size():
				_animate_heart_lost(hearts[i])
	elif new_value > previous_lives:
		_show_all_hearts()

	previous_lives = new_value
	pass

func _on_hook_cooldown_changed(remaining: float, total: float) -> void:
	var progress: float = 0.0
	if total > 0.0:
		progress = 1.0 - (remaining / total)
	
	cooldown_bar.value = progress * 100.0

	if remaining <= 0.0:
		hook_icon.modulate = Color.WHITE
	else:
		hook_icon.modulate = Color(0.5, 0.5, 0.5)
	pass

func _pop_label(label: Label) -> void:
	if score_tween:
		score_tween.kill()
	label.pivot_offset = label.size / 2.0
	label.scale = Vector2.ONE
	label.modulate = Color.WHITE

	score_tween = create_tween().set_parallel()
	var scale_up := score_tween.tween_property(label, "scale", Vector2(1.4, 1.2), 0.08)
	scale_up.set_trans(Tween.TRANS_QUAD)
	scale_up.set_ease(Tween.EASE_OUT)
	score_tween.tween_property(label, "modulate", Color(1.5, 1.4, 0.5), 0.05)

	score_tween.chain()
	var scale_back := score_tween.tween_property(label, "scale", Vector2.ONE, 0.25)
	scale_back.set_trans(Tween.TRANS_BACK)
	scale_back.set_ease(Tween.EASE_OUT)
	score_tween.tween_property(label, "modulate", Color.WHITE, 0.3)
	pass

func _shake_label(label: Label, origin: Vector2) -> void:
	if shake_tween:
		shake_tween.kill()
	label.position = origin
	shake_tween = create_tween()
	for i in 4:
		shake_tween.tween_property(label, "position", origin + Vector2(8, 0), 0.04)
		shake_tween.tween_property(label, "position", origin - Vector2(8, 0), 0.04)
		shake_tween.tween_property(label, "position", origin, 0.04)
	pass

func _show_all_hearts() -> void:
	for heart in hearts:
		heart.modulate = Color.WHITE
		heart.scale = Vector2.ONE
		heart.visible = true
	pass

func _animate_heart_lost(heart: TextureRect) -> void:
	var tween := create_tween().set_parallel()
	tween.tween_property(heart, "scale", Vector2(1.5, 1.5), 0.08) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.chain().tween_property(heart, "scale", Vector2.ZERO, 0.2) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(heart, "modulate:a", 0.0, 0.28)
	pass
