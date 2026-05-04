extends Node2D

@export_group("Instances")
@export var item_scenes: Array[PackedScene]
@export var axe_scene: PackedScene
@export var end_game_scene: PackedScene

@export_group("Difficulty")
@export var initial_spawn_interval: float = 1.5
@export var min_spawn_interval: float = 0.4
@export var initial_fall_speed: float = 200.0
@export var max_fall_speed: float = 500.0
@export var initial_axe_probability: float = 0.10
@export var max_axe_probability: float = 0.5
@export var difficulty_ramp_seconds: float = 60.0

@onready var spawn_timer: Timer = $SpawnTimer

var time_elapsed: float = 0.0

func _ready() -> void:
	GameState.reset()
	spawn_timer.wait_time = initial_spawn_interval
	pass

func _process(delta: float) -> void:
	time_elapsed += delta
	var t: float = clamp(time_elapsed / difficulty_ramp_seconds, 0.0, 1.0)
	spawn_timer.wait_time = lerp(initial_spawn_interval, min_spawn_interval, t)
	pass

func _on_spawn_timer_timeout() -> void:
	var t: float = clamp(time_elapsed / difficulty_ramp_seconds, 0.0, 1.0)
	var current_axe_prob: float = lerp(initial_axe_probability, max_axe_probability, t)
	var current_fall_speed: float = lerp(initial_fall_speed, max_fall_speed, t)

	var scene: PackedScene
	if randf() < current_axe_prob:
		scene = axe_scene
	else:
		scene = item_scenes.pick_random()

	var item = scene.instantiate()
	item.fall_speed = current_fall_speed
	item.global_position = Vector2(randf_range(50, 1100), -20)
	add_child(item)
	pass
