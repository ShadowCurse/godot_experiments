extends KinematicBody

export var min_speed = 10
export var max_speed = 18

var velocity = Vector3.ZERO

signal squashed

func _physics_process(delta):
	move_and_slide(velocity)

func initialize(start_pos, player_pos):
	translation = start_pos
	look_at(player_pos, Vector3.UP)
	rotate_y(rand_range(-PI / 4, PI / 4))
	var random_speed = rand_range(min_speed, max_speed)
	$AnimationPlayer.playback_speed = random_speed / min_speed
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func squash():
	emit_signal("squashed")
	queue_free()

func _on_VisibilityNotifier_screen_exited():
	queue_free()
