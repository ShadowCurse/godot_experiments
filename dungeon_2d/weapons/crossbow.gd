extends Node2D

@export var bolt: PackedScene

var in_attack_animation: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func attack(player_pos: Vector2, cursor_pos: Vector2) -> void:
	if not self.in_attack_animation:
		var direction = cursor_pos - player_pos
		self.position = direction.normalized() * 5.0
		self.rotation = direction.angle()
		self.in_attack_animation = true
		$AnimationPlayer.play("attack_appear")
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"attack_appear":
			$AnimatedSprite2D.play()
		"attack_disappear":
			self.in_attack_animation = false


func _on_animated_sprite_2d_animation_finished() -> void:
	var bolt_instance = bolt.instantiate()
	get_tree().root.get_child(0).add_child(bolt_instance)
	bolt_instance.global_position = self.global_position
	bolt_instance.rotation = self.global_rotation
	$AnimationPlayer.play("attack_disappear")
