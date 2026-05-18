extends CanvasLayer

@export var intensity_scale: float = 0.4
@export var trauma_reduction_rate: float = 1.5

var trauma: float = 0.0
var max_offset: Vector2 = Vector2(25.0, 15.0)

func _ready() -> void:
    Events.screen_shake_requested.connect(_on_shake_requested)
    pass

func _process(delta: float) -> void:
    if trauma > 0.0:
        trauma = max(trauma - delta * trauma_reduction_rate, 0.0)
        var amount: float = pow(trauma, 2)
        offset = Vector2(
            max_offset.x * amount * randf_range(-1.0, 1.0),
            max_offset.y * amount * randf_range(-1.0, 1.0)
        )
    else:
        offset = Vector2.ZERO
    pass

func _on_shake_requested(intensity: float) -> void:
    trauma = clamp(trauma + intensity * intensity_scale, 0.0, 1.0)
    pass