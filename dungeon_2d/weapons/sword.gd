extends Area2D

@export var hit_world_effect: PackedScene

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$CollisionShape2D.disabled = true


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

func attack(player_pos: Vector2, cursor_pos: Vector2) -> void:
	self.visible = true
	var direction = cursor_pos - player_pos
	self.position = direction.normalized() * 5.0
	self.rotation = direction.angle()
	$CollisionShape2D.disabled = false
	$AnimationPlayer.play("attack")
