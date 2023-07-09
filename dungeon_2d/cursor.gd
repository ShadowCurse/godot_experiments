extends Node2D

func _process(delta: float) -> void:
	self.position = get_global_mouse_position()
