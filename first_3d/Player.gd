extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var bounce_impulse = 16

signal hit

func _init() -> void:
	velocity = Vector3.ZERO

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= fall_acceleration * delta

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_impulse
	
	var input_dir := Input.get_vector("left", "right", "back", "forward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		$Pivot.look_at(position + direction, Vector3.UP)
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		var collider = collision.get_collider()
		if (collider == null):
			continue
		if collider.is_in_group("mob"):
			var mob = collider
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()
				velocity.y = bounce_impulse
	
	move_and_slide()

func die():
	hit.emit()
	queue_free()

func _on_MobDetector_body_entered(body):
	die()
