extends Control

@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var score_label: Label = $VBoxContainer/ScoreLabel
@onready var retry_button: Button = $VBoxContainer/RetryButton
@onready var menu_button: Button = $VBoxContainer/MenuButton

func _ready() -> void:
    modulate.a = 0.0
    var tween := create_tween()
    tween.tween_property(self , "modulate:a", 1.0, 0.4)
    
    if GameState.last_result == GameState.Result.VICTORY:
        title_label.text = "¡Ganaste!"
    else:
        title_label.text = "¡Perdiste!"
    
    score_label.text = "Score : " + str(GameState.score)
    retry_button.pressed.connect(_on_retry_pressed)
    menu_button.pressed.connect(_on_menu_pressed)
    pass

func _on_retry_pressed() -> void:
    SceneManager.switch_scene("game")
    pass

func _on_menu_pressed() -> void:
    SceneManager.switch_scene("main_menu")
    pass