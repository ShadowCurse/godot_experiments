extends Control

@export var start_scene: PackedScene

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_scene)

func _on_fullscreen_pressed() -> void:
	get_tree().root.mode = Window.MODE_FULLSCREEN


func _on_windowed_pressed() -> void:
	get_tree().root.mode = Window.MODE_WINDOWED

func _on_exit_pressed() -> void:
	get_tree().quit()
