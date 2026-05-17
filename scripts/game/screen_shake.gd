extends Camera2D

@export var trauma_reduction_rate: float = 1.5

var trauma: float = 0.0
var max_shake_offset: Vector2 = Vector2(30.0, 20.0)
var max_shake_rotation: float = 0.5

func _ready() -> void:
	Events.screen_shake_requested.connect(_on_shake_requested)
	pass

func _process(delta: float) -> void:
	if trauma > 0.0:
		trauma = max(trauma - delta * trauma_reduction_rate, 0.0)
		_apply_shake()
	else:
		offset = Vector2.ZERO
		rotation = 0.0
	pass

func _apply_shake() -> void:
	var amount: float = pow(trauma, 2)
	offset = Vector2(
		max_shake_offset.x * amount * randf_range(-1.0, 1.0),
		max_shake_offset.y * amount * randf_range(-1.0, 1.0)
	)
	rotation = max_shake_rotation * amount * randf_range(-1.0, 1.0)
	pass

func _on_shake_requested(intensity: float) -> void:
	trauma = clamp(trauma + intensity, 0.0, 1.0)
	pass
