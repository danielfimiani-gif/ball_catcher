extends Area2D

@export var fall_speed: float = 180.0
@export var power_up_type: String = "speed_boost"
@export var duration: float = 5.0

func _physics_process(delta: float) -> void:
    position.y += fall_speed * delta
    if position.y > 700:
        queue_free()
    pass