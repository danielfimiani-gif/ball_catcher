extends Button

@export var hover_scale: float = 1.1
@export var click_scale: float = 0.92
@export var hover_color: Color = Color(1.15, 1.15, 1.15)
@export var animation_speed: float = 0.1

var _tween: Tween
var _is_hovered: bool = false
var _is_focused: bool = false

func _ready() -> void:
    resized.connect(_update_pivot)
    _update_pivot()
    mouse_entered.connect(_on_mouse_entered)
    mouse_exited.connect(_on_mouse_exited)
    focus_entered.connect(_on_focus_entered)
    focus_exited.connect(_on_focus_exited)
    pressed.connect(_on_pressed)
    pass

func _update_pivot() -> void:
    pivot_offset = size / 2.0
    pass

func _on_mouse_entered() -> void:
    _is_hovered = true
    _update_visual()
    pass

func _on_mouse_exited() -> void:
    _is_hovered = false
    _update_visual()
    pass

func _on_focus_entered() -> void:
    _is_focused = true
    _update_visual()
    pass

func _on_focus_exited() -> void:
    _is_focused = false
    _update_visual()
    pass

func _on_pressed() -> void:
    _kill_tween()
    _tween = create_tween()
    var down := _tween.tween_property(self , "scale", Vector2(click_scale, click_scale), 0.05)
    down.set_trans(Tween.TRANS_QUAD)
    down.set_ease(Tween.EASE_OUT)
    var up := _tween.tween_property(self , "scale", Vector2(hover_scale, hover_scale), 0.12)
    up.set_trans(Tween.TRANS_BACK)
    up.set_ease(Tween.EASE_OUT)
    pass

func _update_visual() -> void:
    if _is_hovered or _is_focused:
            _animate_to(Vector2(hover_scale, hover_scale), hover_color)
    else:
            _animate_to(Vector2.ONE, Color.WHITE)
    pass

func _animate_to(target_scale: Vector2, target_color: Color) -> void:
    _kill_tween()
    _tween = create_tween().set_parallel()
    _tween.tween_property(self , "scale", target_scale, animation_speed)
    _tween.tween_property(self , "modulate", target_color, animation_speed)
    pass

func _kill_tween() -> void:
    if _tween:
            _tween.kill()
    pass