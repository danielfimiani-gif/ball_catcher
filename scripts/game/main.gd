extends Node2D

@export_group("Instances")
@export var item_scenes: Array[PackedScene]
@export var powerup_scenes: Array[PackedScene]
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
@export var power_up_probability: float = 0.05

@onready var spawn_timer: Timer = $SpawnTimer
@onready var countdown_label: Label = $UI/CountDownLabel

var time_elapsed: float = 0.0
var countdown_running: bool = true
var countdown_tween: Tween

func _ready() -> void:
	GameState.reset()
	spawn_timer.wait_time = initial_spawn_interval
	spawn_timer.stop()
	AudioManager._play_music("game")
	_run_countdown()
	pass

func _process(delta: float) -> void:
	if countdown_running:
		return

	time_elapsed += delta
	var t: float = clamp(time_elapsed / difficulty_ramp_seconds, 0.0, 1.0)
	spawn_timer.wait_time = lerp(initial_spawn_interval, min_spawn_interval, t)
	pass

func _on_spawn_timer_timeout() -> void:
	var t: float = clamp(time_elapsed / difficulty_ramp_seconds, 0.0, 1.0)
	var current_axe_prob: float = lerp(initial_axe_probability, max_axe_probability, t)
	var current_fall_speed: float = lerp(initial_fall_speed, max_fall_speed, t)

	var scene: PackedScene
	if not powerup_scenes.is_empty() and randf() < power_up_probability:
		scene = powerup_scenes.pick_random()
	elif randf() < current_axe_prob:
		scene = axe_scene
	else:
		scene = item_scenes.pick_random()

	var item = scene.instantiate()
	if "fall_speed" in item:
		item.fall_speed = current_fall_speed
	item.global_position = Vector2(randf_range(50, 1100), -20)
	add_child(item)
	pass

func _run_countdown() -> void:
	var numbers: Array[String] = ["3", "2", "1", "GO!"]
	for number in numbers:
		countdown_label.text = number
		countdown_label.pivot_offset = countdown_label.size / 2.0
		countdown_label.scale = Vector2(2.5, 2.5)
		countdown_label.modulate.a = 1.0
		AudioManager._play_sfx("click")
		_animate_countdown_number()
		await get_tree().create_timer(0.7).timeout
	countdown_running = false
	spawn_timer.start()
	pass
       
func _animate_countdown_number() -> void:
	if countdown_tween:
		countdown_tween.kill()
	countdown_tween = create_tween().set_parallel()

	var tween := create_tween().set_parallel()
	var target_scale := Vector2.ONE
	var scale_anim := tween.tween_property(countdown_label, "scale", target_scale, 0.3)
	scale_anim.set_trans(Tween.TRANS_BACK)
	scale_anim.set_ease(Tween.EASE_OUT)
	var fade_anim := tween.tween_property(countdown_label, "modulate:a", 0.0, 0.5)
	fade_anim.set_trans(Tween.TRANS_QUAD)
	fade_anim.set_ease(Tween.EASE_IN)
	pass
