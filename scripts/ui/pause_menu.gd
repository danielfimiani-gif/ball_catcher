extends Control

@onready var resume_button: Button = $VBoxContainer/ResumeButton
@onready var menu_button: Button = $VBoxContainer/MenuButton
@onready var exit_button: Button = $VBoxContainer/ExitButton

func _ready() -> void:
    visible = false
    resume_button.pressed.connect(_on_resume_pressed)
    menu_button.pressed.connect(_on_menu_pressed)
    exit_button.pressed.connect(_on_exit_pressed)
    resume_button.mouse_entered.connect(_on_button_hover)
    menu_button.mouse_entered.connect(_on_button_hover)
    exit_button.mouse_entered.connect(_on_button_hover)

    if OS.has_feature("web"):
        exit_button.visible = false
    pass

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        _toggle_pause()
        get_viewport().set_input_as_handled()
    pass

func _toggle_pause() -> void:
    if visible:
        _resume()
    else:
        _pause()
    pass

func _pause() -> void:
    visible = true
    get_tree().paused = true
    resume_button.grab_focus()
    pass

func _resume() -> void:
    visible = false
    get_tree().paused = false
    pass

func _on_resume_pressed() -> void:
    AudioManager._play_sfx("click")
    _resume()
    pass

func _on_menu_pressed() -> void:
    AudioManager._play_sfx("click")
    get_tree().paused = false
    SceneManager.switch_scene("main_menu")
    pass

func _on_exit_pressed() -> void:
    AudioManager._play_sfx("click")
    get_tree().quit()
    pass

func _on_button_hover() -> void:
    AudioManager._play_sfx("hover")
    pass