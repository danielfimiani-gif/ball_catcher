extends Control

@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var score_label: Label = $VBoxContainer/ScoreLabel
@onready var retry_button: Button = $VBoxContainer/RetryButton
@onready var menu_button: Button = $VBoxContainer/MenuButton
@onready var new_highscore_label: Label = $VBoxContainer/NewHighScoreLabel

func _ready() -> void:
    modulate.a = 0.0
    var tween := create_tween()
    tween.tween_property(self , "modulate:a", 1.0, 0.4)
    
    if GameState.last_result == GameState.Result.VICTORY:
        title_label.text = "¡Ganaste!"
        AudioManager._play_sfx("victory")
    else:
        title_label.text = "¡Perdiste!"
        AudioManager._play_sfx("game_over")
    
    score_label.text = "Score : " + str(GameState.score)
    new_highscore_label.visible = GameState.was_new_highscore
    
    if GameState.was_new_highscore:
        _animate_new_record()
        _play_highscore_delayed()
    
    retry_button.pressed.connect(_on_retry_pressed)
    menu_button.pressed.connect(_on_menu_pressed)
    retry_button.mouse_entered.connect(_on_button_hover)
    menu_button.mouse_entered.connect(_on_button_hover)
    
    pass

func _on_retry_pressed() -> void:
    AudioManager._play_sfx("click")
    SceneManager.switch_scene("game")
    pass

func _on_menu_pressed() -> void:
    AudioManager._play_sfx("click")
    SceneManager.switch_scene("main_menu")
    pass

func _on_button_hover() -> void:
    AudioManager._play_sfx("hover")
    pass

func _play_highscore_delayed() -> void:
    await get_tree().create_timer(0.6).timeout
    AudioManager._play_sfx("high_score")
    pass

func _animate_new_record() -> void:
    await get_tree().process_frame
    new_highscore_label.pivot_offset = new_highscore_label.size / 2.0

    var tween := create_tween().set_loops()
    tween.tween_property(new_highscore_label, "scale", Vector2(1.5, 1.5), 1.2) \
        .set_trans(Tween.TRANS_SINE) \
        .set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(new_highscore_label, "scale", Vector2(1.0, 1.0), 1.50) \
        .set_trans(Tween.TRANS_SINE) \
        .set_ease(Tween.EASE_IN_OUT)
    tween.tween_interval(0.3)
    pass