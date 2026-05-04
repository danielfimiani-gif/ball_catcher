extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var lives_label: Label = $LivesLabel

func _ready() -> void:
    GameState.score_changed.connect(_on_score_changed)
    GameState.lives_changed.connect(_on_lives_changed)

    _on_lives_changed(GameState.lives)
    _on_score_changed(GameState.score)

    pass

func _on_score_changed(new_value: int) -> void:
    score_label.text = "Score : " + str(new_value)
    _pop_label(score_label)
    pass

func _on_lives_changed(new_value: int) -> void:
    lives_label.text = "Lives : " + str(new_value)
    _shake_label(lives_label)
    pass

func _pop_label(label: Label) -> void:
    var tween := create_tween()
    tween.tween_property(label, "scale", Vector2(1.3, 1.3), 0.1)
    tween.tween_property(label, "scale", Vector2.ONE, 0.15)
    pass

func _shake_label(label: Label) -> void:
    var original_position := label.position
    var tween := create_tween()
    for i in 4:
        tween.tween_property(label, "position", original_position + Vector2(8, 0), 0.04)
        tween.tween_property(label, "position", original_position - Vector2(8, 0), 0.04)
        tween.tween_property(label, "position", original_position, 0.04)
    pass
