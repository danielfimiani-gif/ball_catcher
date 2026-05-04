extends Area2D

@export var fall_speed: float = 200.0
@export var points: int = 10

func _physics_process(delta: float) -> void:
	position.y += fall_speed * delta
	if position.y > 700:
		queue_free()
	pass
