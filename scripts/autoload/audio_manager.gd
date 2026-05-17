extends Node

# === MUSIC ===
const MUSIC_MENU: AudioStream = preload("res://assets/audio/music/menu.mp3")
const MUSIC_GAME: AudioStream = preload("res://assets/audio/music/game.mp3")

const MUSIC_TRACKS: Dictionary = {
    "menu": MUSIC_MENU,
    "game": MUSIC_GAME
}

# === SFX ===
const SFX_HOVER: AudioStream = preload("res://assets/audio/sfx/ui/hover.wav")
const SFX_CLICK: AudioStream = preload("res://assets/audio/sfx/ui/click.wav")
const SFX_PICK_UP_ITEM: AudioStream = preload("res://assets/audio/sfx/items/pickup_item.wav")
const SFX_PICK_AXE: AudioStream = preload("res://assets/audio/sfx/items/pick_axe.wav")
const SFX_VICTORY: AudioStream = preload("res://assets/audio/sfx/game/victory.mp3")
const SFX_GAME_OVER: AudioStream = preload("res://assets/audio/sfx/game/game_over.mp3")
const SFX_HIGH_SCORE: AudioStream = preload("res://assets/audio/sfx/game/high_score.mp3")

const SFX_LIBRARY: Dictionary = {
    "hover": SFX_HOVER,
    "click": SFX_CLICK,
    "pick_item": SFX_PICK_UP_ITEM,
    "pick_axe": SFX_PICK_AXE,
    "victory": SFX_VICTORY,
    "game_over": SFX_GAME_OVER,
    "high_score": SFX_HIGH_SCORE
}

var music_player = AudioStreamPlayer
var current_music: String = ""

func _ready() -> void:
    music_player = AudioStreamPlayer.new()
    music_player.bus = "Music"
    add_child(music_player)
    pass

func _play_music(track_name: String) -> void:
    if current_music == track_name and music_player.playing:
        return
    
    var stream: AudioStream = MUSIC_TRACKS.get(track_name)
    if stream == null:
        push_warning("Music track not found: " + track_name)
        return
    
    current_music = track_name
    music_player.stream = stream
    music_player.play()
    pass

func _stop_music() -> void:
    music_player.stop()
    current_music = ""
    pass

func _play_sfx(sfx_name: String, pitch_variation: float = 0.0) -> void:
    var stream: AudioStream = SFX_LIBRARY.get(sfx_name)
    if stream == null:
        push_warning("SFX track not found: " + sfx_name)
        return
    
    var player := AudioStreamPlayer.new()
    player.stream = stream
    player.bus = "SFX"
    if pitch_variation > 0.0:
        player.pitch_scale = 1.0 + randf_range(-pitch_variation, pitch_variation)
    
    add_child(player)
    player.finished.connect(player.queue_free)
    player.play()
    pass