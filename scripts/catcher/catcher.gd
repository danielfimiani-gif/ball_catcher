extends CharacterBody2D

# Movement
@export var speed: float = 400.0
@export var margin: float = 30.0
# Effects
@export var damage_flash_color: Color = Color(1.8, 0.4, 0.4, 1.0)
@export var damage_flash_in: float = 0.05
@export var damage_flash_out: float = 0.25

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var half_width: float = (collision.shape as RectangleShape2D).size.x / 2.0
@onready var viewport_width: float = get_viewport_rect().size.x

var flash_tween: Tween

func _physics_process(_delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed
	move_and_slide()
	global_position.x = clamp(
		global_position.x,
		half_width + margin,
		viewport_width - half_width - margin
	)
	_update_animation(direction)
	pass


func _update_animation(direction: float) -> void:
	if direction == 0.0:
		sprite.play("idle")
	else:
		sprite.play("walk")
		sprite.flip_h = direction < 0.0
	pass

func _on_catch_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("axes"):
		AudioManager._play_sfx("pick_axe", 0.1)
		Events.screen_shake_requested.emit(0.5)
		_apply_hit_stop(0.15)
		_flash_damage()
		GameState.lives -= 1
		area.queue_free()
	elif area.is_in_group("items"):
		AudioManager._play_sfx("pick_item", 0.15)
		Events.screen_shake_requested.emit(0.15)
		GameState.score += area.points
		area.queue_free()
	pass

func _apply_hit_stop(duration: float) -> void:
	Engine.time_scale = 0.02
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0
	pass

func _flash_damage() -> void:
	if flash_tween:
		flash_tween.kill()
	
	flash_tween = create_tween()
	flash_tween.tween_property(sprite, "modulate", damage_flash_color, damage_flash_in)
	flash_tween.tween_property(sprite, "modulate", Color.WHITE, damage_flash_out)
	pass