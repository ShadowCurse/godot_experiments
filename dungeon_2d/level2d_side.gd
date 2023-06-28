extends Node2D

@export var next_scene: String
signal next_scene_signal(scene: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$knight.controls_type = $knight.Controls.SideScroll


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_scene_change_body_entered(body: Node2D) -> void:
	self.next_scene_signal.emit(self.next_scene)


func deconstruct():
	self.queue_free()
	
	
func _on_door_opened() -> void:
	$scene_change/CollisionShape2D.disabled = false
