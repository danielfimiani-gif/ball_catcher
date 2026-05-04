extends Area2D

signal dodged

@export var fall_speed: float = 200.0
@export var spin_speed: float = 4.0

@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	position.y += fall_speed * delta
	sprite.rotation += spin_speed * delta
	if position.y > 700:
		dodged.emit()
		queue_free()
	pass
