extends Node

const FADE_DURATION: float = 0.3

var scenes: Dictionary = {
    "main_menu": "res://scenes/ui/main_menu.tscn",
    "game": "res://scenes/main.tscn",
    "end_game": "res://scenes/ui/end_game.tscn"
}

var canvas_layer: CanvasLayer
var fade_rect: ColorRect

func _ready() -> void:
    _setup_fade_overlay()
    process_mode = Node.PROCESS_MODE_ALWAYS
    pass

func _setup_fade_overlay() -> void:
    canvas_layer = CanvasLayer.new()
    canvas_layer.layer = 100
    add_child(canvas_layer)

    fade_rect = ColorRect.new()
    fade_rect.color = Color.BLACK
    fade_rect.modulate.a = 0.0
    fade_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
    fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
    canvas_layer.add_child(fade_rect)
    pass

func switch_scene(scene_name: String):
    var path: String = scenes.get(scene_name, "")
    if path == "":
        return
    
    await _fade_out()
    get_tree().change_scene_to_file(path)
    await get_tree().process_frame
    await _fade_in()
    pass

func _fade_out() -> void:
    fade_rect.mouse_filter = Control.MOUSE_FILTER_STOP
    var tween := create_tween()
    tween.tween_property(fade_rect, "modulate:a", 1.0, FADE_DURATION)
    await tween.finished
    pass

func _fade_in() -> void:
    var tween := create_tween()
    tween.tween_property(fade_rect, "modulate:a", 0.0, FADE_DURATION)
    await tween.finished
    fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
    pass