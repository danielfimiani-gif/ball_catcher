extends Label

@export var rise_distance: float = 80.0
@export var duration: float = 0.7

func _ready() -> void:
    pivot_offset = size / 2.0
    var tween := create_tween().set_parallel()
    tween.tween_property(self , "position:y", position.y - rise_distance, duration) \
        .set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(self , "modulate:a", 0.0, duration) \
        .set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
    tween.finished.connect(queue_free)
    pass