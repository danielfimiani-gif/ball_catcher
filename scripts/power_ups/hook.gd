extends Node2D

@onready var rope: Line2D = $"Rope"
@onready var hook_head: Area2D = $"Head"

@export var speed: float = 1200.0
@export var max_range: float = 550.0
@export var pull_speed_multiplier: float = 1.3
@export var sprite_rotation_offset: float = 0.0

signal item_returned(item: Area2D)

enum State {
	IDLE,
	EXTENDING,
	PULLING,
	RETURNING
}


var state: State = State.IDLE
var shoot_dir: Vector2 = Vector2.ZERO
var shoot_origin: Vector2 = Vector2.ZERO
var hook_world_pos: Vector2 = Vector2.ZERO
var captured_item: Area2D = null
var catcher_ref: Node2D = null

func _ready() -> void:
	visible = false
	hook_head.area_entered.connect(_on_area_entered)
	pass

func _process(delta: float) -> void:
	match state:
		State.EXTENDING:
			hook_world_pos += shoot_dir * speed * delta
			if hook_world_pos.distance_to(shoot_origin) >= max_range:
				state = State.RETURNING
		State.PULLING, State.RETURNING:
			if catcher_ref == null:
				state = State.IDLE
				visible = false
				return
			
			var to_catcher: Vector2 = catcher_ref.global_position - hook_world_pos
			var step: float = speed * pull_speed_multiplier * delta
			if to_catcher.length() <= step:
				_arrive_at_origin()
				return
			hook_world_pos += to_catcher.normalized() * step
		State.IDLE:
			return
	
	_update_visual()
	pass

func _on_area_entered(area: Area2D) -> void:
	if state != State.EXTENDING:
		return
	
	if not (area.is_in_group("items") or area.is_in_group("power_ups")):
		return
	captured_item = area
	if area.has_method("set_physics_process"):
		area.set_physics_process(false)
	state = State.PULLING
	pass

func _arrive_at_origin() -> void:
	if captured_item != null:
		item_returned.emit(captured_item)
		captured_item = null
	
	state = State.IDLE
	visible = false
	pass

func _is_idle() -> bool:
	return state == State.IDLE

func _shoot(catcher: Node2D, target_global: Vector2) -> void:
	if !_is_idle():
		return
	catcher_ref = catcher
	shoot_origin = catcher.global_position
	shoot_dir = (target_global - shoot_origin).normalized()
	hook_world_pos = shoot_origin
	captured_item = null
	state = State.EXTENDING
	visible = true
	pass

func _update_visual() -> void:
	hook_head.global_position = hook_world_pos

	if catcher_ref != null:
		var dir_to_hook: Vector2 = (hook_world_pos - catcher_ref.global_position).normalized()
		if dir_to_hook.length() > 0.1:
			hook_head.rotation = dir_to_hook.angle() + sprite_rotation_offset
		var catcher_local: Vector2 = to_local(catcher_ref.global_position)
		var hook_local: Vector2 = to_local(hook_world_pos)
		rope.points = [catcher_local, hook_local]
	
	if captured_item != null:
		captured_item.global_position = hook_world_pos
	pass
