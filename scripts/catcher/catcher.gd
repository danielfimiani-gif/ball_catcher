extends CharacterBody2D

@export_group("Movement")
@export var speed: float = 400.0
@export var margin: float = 30.0
@export var hook_cooldown: float = 1.7

@export_group("Effects")
@export var damage_flash_color: Color = Color(1.8, 0.4, 0.4, 1.0)
@export var damage_flash_in: float = 0.05
@export var damage_flash_out: float = 0.25
@export var catch_squash_factor: Vector2 = Vector2(1.2, 0.8)
@export var hit_stretch_factor: Vector2 = Vector2(0.8, 1.2)
@export var move_stretch_factor: Vector2 = Vector2(0.85, 1.15)
@export var wall_stretch_factor: Vector2 = Vector2(1.3, 0.7)
@export var squash_in: float = 0.08
@export var squash_out: float = 0.25

@export_group("PackedScenes")
@export var catch_particles_scene: PackedScene
@export var damage_particles_scene: PackedScene
@export var floating_text_scene: PackedScene
@export var hook_scene: PackedScene

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var half_width: float = (collision.shape as RectangleShape2D).size.x / 2.0
@onready var viewport_width: float = get_viewport_rect().size.x
@onready var sprite_base_scale: Vector2 = sprite.scale
@onready var base_speed: float = speed

var flash_tween: Tween
var squash_tween: Tween
var previous_direction: float = 0.0
var wall_bumped: bool = false
var boost_timer: float = 0.0
var hook: Node2D
var hook_cooldown_remaining: float = 0.0

func _ready() -> void:
	if hook_scene != null:
		hook = hook_scene.instantiate()
		get_tree().current_scene.add_child.call_deferred(hook)
		hook.item_returned.connect(_on_hook_item_returned)
	pass

func _process(delta: float) -> void:
	if boost_timer > 0.0:
		boost_timer -= delta
		if boost_timer <= 0.0:
			speed = base_speed
			boost_timer = 0.0
	if hook_cooldown_remaining > 0.0:
		hook_cooldown_remaining -= delta
		if hook_cooldown_remaining < 0.0:
			hook_cooldown_remaining = 0.0
		Events.hook_cooldown_changed.emit(hook_cooldown_remaining, hook_cooldown)
	pass

func _physics_process(_delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed
	move_and_slide()

	var position_begore_clamp: float = global_position.x
	global_position.x = clamp(
		global_position.x,
		half_width + margin,
		viewport_width - half_width - margin
	)
	var is_clamped: bool = position_begore_clamp != global_position.x

	if is_clamped and not wall_bumped:
		wall_bumped = true
		_on_wall_bump()
	elif not is_clamped:
		wall_bumped = false

	_update_animation(direction)
	_check_movement_squash(direction)
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_try_shoot_hook()
	pass

func _try_shoot_hook() -> void:
	if hook == null:
		return
	if not hook._is_idle():
		return
	if hook_cooldown_remaining > 0.0:
		return
	
	hook._shoot(self , get_global_mouse_position())
	hook_cooldown_remaining = hook_cooldown
	Events.hook_cooldown_changed.emit(hook_cooldown, hook_cooldown)
	pass

func _on_hook_item_returned(item: Area2D) -> void:
	if item.is_in_group("power_ups"):
		_handle_powerup_caught(item)
	elif item.is_in_group("items"):
		_handle_item_caught(item)
	pass

func _update_animation(direction: float) -> void:
	if direction == 0.0:
		sprite.play("idle")
	else:
		if boost_timer > 0.0:
			sprite.play("run")
		else:
			sprite.play("walk")
		sprite.flip_h = direction < 0.0
	pass

func _on_catch_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("axes"):
		_handle_axe_caught(area)
	elif area.is_in_group("power_ups"):
		_handle_powerup_caught(area)
	elif area.is_in_group("items"):
		_handle_item_caught(area)
	pass

func _handle_axe_caught(axe: Area2D) -> void:
	AudioManager._play_sfx("pick_axe", 0.1)
	Events.screen_shake_requested.emit(0.5)
	_apply_hit_stop(0.15)
	_flash_damage()
	_spawn_particles(damage_particles_scene, axe.global_position)
	_spawn_floating_text("-1", axe.global_position, Color(1.0, 0.3, 0.3))
	_apply_squash(hit_stretch_factor)
	GameState.lives -= 1
	axe.queue_free()
	pass

func _handle_item_caught(item: Area2D) -> void:
	AudioManager._play_sfx("pick_item", 0.15)
	Events.screen_shake_requested.emit(0.15)
	_spawn_particles(catch_particles_scene, item.global_position)
	_spawn_floating_text("+" + str(item.points), item.global_position, Color(1.0, 0.95, 0.4))
	_apply_squash(catch_squash_factor)
	GameState.score += item.points
	item.queue_free()
	pass

func _handle_powerup_caught(item: Area2D) -> void:
	AudioManager._play_sfx("pick_item", 0.2)
	Events.screen_shake_requested.emit(0.3)
	_spawn_particles(catch_particles_scene, item.global_position)
	_apply_squash(catch_squash_factor)

	if item.power_up_type == "speed_boost":
		_spawn_floating_text("SPEED!", item.global_position, Color(0.4, 1.0, 1.0))
		_activate_speed_boost(item.duration)
	item.queue_free()
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

func _spawn_particles(scene: PackedScene, pos: Vector2) -> void:
	if scene == null:
		return
	
	var particles: CPUParticles2D = scene.instantiate()
	get_tree().current_scene.add_child(particles)
	particles.global_position = pos
	particles.emitting = true
	pass

func _spawn_floating_text(text: String, pos: Vector2, color: Color = Color.WHITE) -> void:
	if floating_text_scene == null:
		return
	
	var label: Label = floating_text_scene.instantiate()
	label.text = text
	label.modulate = color
	get_tree().current_scene.add_child(label)
	label.global_position = pos
	pass

func _apply_squash(factor: Vector2) -> void:
	if squash_tween:
		squash_tween.kill()
	
	var target_scale: Vector2 = sprite_base_scale * factor
	squash_tween = create_tween()
	squash_tween.tween_property(sprite, "scale", target_scale, squash_in) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	squash_tween.tween_property(sprite, "scale", sprite_base_scale, squash_out) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	pass

func _check_movement_squash(direction: float) -> void:
	var started_moving: bool = direction != 0.0 and previous_direction == 0.0
	var changed_dir: bool = direction != 0.0 and previous_direction != 0.0 and sign(direction) != sign(previous_direction)
	if started_moving or changed_dir:
		_apply_squash(move_stretch_factor)
	
	previous_direction = direction
	pass

func _on_wall_bump() -> void:
	_apply_squash(wall_stretch_factor)
	Events.screen_shake_requested.emit(0.25)
	pass

func _activate_speed_boost(boost_duration: float) -> void:
	speed = base_speed * 2.0
	boost_timer = boost_duration
	pass
