extends Area2D

@export var hit_world_effect: PackedScene

func _ready() -> void:
	$AnimationPlayer.play("attack")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	self.queue_free()


func _on_body_exited(body: Node2D) -> void:
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
