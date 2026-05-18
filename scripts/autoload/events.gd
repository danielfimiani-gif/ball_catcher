extends Node

@warning_ignore_start("unused_signal")
signal screen_shake_requested(intensity: float)
signal hook_cooldown_changed(remaining: float, total: float)
@warning_ignore_restore("unused_signal")