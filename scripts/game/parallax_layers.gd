extends Node2D

@export var catcher_path: NodePath
@export var smoothing_speed: float = 5.0

const SCROLL_SCALES: Dictionary = {
	"Layer1": 0.04,
	"Layer2": 0.07,
	"Layer3": 0.10,
	"Layer4": 0.15,
	"Layer5": 0.22,
	"Layer6": 0.32,
	#"Layer7": 0.45, Keep the floor static.
}

var catcher: Node2D
var viewport_center_x: float
var smoothed_offset: float = 0.0

func _ready() -> void:
	catcher = get_node(catcher_path)
	viewport_center_x = get_viewport_rect().size.x / 2.0
	pass

func _process(delta: float) -> void:
	if catcher == null:
		return
	
	var target_offset: float = catcher.global_position.x - viewport_center_x
	smoothed_offset = lerp(smoothed_offset, target_offset, delta * smoothing_speed)
	
	for layer_name in SCROLL_SCALES:
		var layer: Parallax2D = get_node(layer_name)
		layer.scroll_offset.x = - smoothed_offset * SCROLL_SCALES[layer_name]

	pass
