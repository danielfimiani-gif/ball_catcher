extends CharacterBody2D

@export var speed: float = 400.0

func _physics_process(_delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed
	move_and_slide()
	pass

func _on_catch_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("axes"):
		GameState.lives -= 1
		area.queue_free()
	elif area.is_in_group("items"):
		GameState.score += area.points
		area.queue_free()
	pass
