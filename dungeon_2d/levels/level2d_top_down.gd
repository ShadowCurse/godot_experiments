extends Node2D

@export var next_scene: String
signal next_scene_signal(scene: String)

func _ready() -> void:
	$knight.controls_type = $knight.Controls.TopDown
	$knight.setup_camera($TileMap.get_used_rect(), $TileMap.tile_set.tile_size, $TileMap.scale)
	$knight.setup_weapons()

func _process(delta: float) -> void:
	pass

func _on_scene_change_body_entered(body: Node2D) -> void:
	self.next_scene_signal.emit(self.next_scene)

func deconstruct():
	self.queue_free()

func _on_door_opened() -> void:
	$scene_change/CollisionShape2D.disabled = false
