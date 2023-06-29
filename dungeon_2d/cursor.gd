extends Node2D

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.position = event.position
