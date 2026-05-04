extends Node

var scenes = {
    "main_menu": "res://scenes/ui/main_menu.tscn",
    "game": "res://scenes/main.tscn",
    "end_game": "res://scenes/ui/end_game.tscn"
}

func switch_scene(scene_name: String):
    var path = scenes.get(scene_name)
    if path:
        get_tree().call_deferred("change_scene_to_file", path)