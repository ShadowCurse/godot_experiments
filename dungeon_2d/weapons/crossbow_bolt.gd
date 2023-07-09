extends Area2D

@export var hit_world_effect: PackedScene

const SPEED: float = 500.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(self.rotation)
	self.position += direction * SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	var direction = Vector2.RIGHT.rotated(self.rotation)
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(self.global_position, self.global_position + direction * 100.0)
	var result = space_state.intersect_ray(query)
	if result:
		var effect = hit_world_effect.instantiate()
		get_tree().root.get_child(0).add_child(effect)
		effect.global_position = result["position"]
		effect.rotation = result["normal"].angle()
		effect.emitting = true
	self.queue_free()
