extends CharacterBody2D

const SPEED = 300.0
const JUMP = -444.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var has_key: bool = false

enum Controls {
	TopDown,
	SideScroll
}

var controls_type: Controls = Controls.TopDown

func setup_camera(map_limits: Rect2i, map_cellsize: Vector2, map_scale: Vector2):
	$Camera2D.limit_left = map_limits.position.x * map_cellsize.x * map_scale.x
	$Camera2D.limit_right = map_limits.end.x * map_cellsize.x * map_scale.x
	$Camera2D.limit_top = map_limits.position.y * map_cellsize.y * map_scale.y
	$Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y * map_scale.y

func _physics_process(delta: float) -> void:
	match controls_type:
		Controls.TopDown:
			physics_process_top_down(delta)
		Controls.SideScroll:
			physics_process_side_scroll(delta)
			
	
func physics_process_top_down(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		self.velocity.x = direction.x * SPEED
		self.velocity.y = direction.y * SPEED
	else:
		self.velocity.x = move_toward(self.velocity.x, 0, SPEED)
		self.velocity.y = move_toward(self.velocity.y, 0, SPEED)

	if self.velocity.length_squared() != 0:
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.play()
		
	if self.velocity.x != 0:
		$AnimatedSprite2D.flip_h = self.velocity.x < 0
	move_and_slide()
	
func physics_process_side_scroll(delta: float) -> void:
	velocity.y += gravity * delta
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		self.velocity.x = direction * SPEED
	else:
		self.velocity.x = move_toward(self.velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		velocity.y = JUMP

	if self.velocity.x != 0:
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.play()
		
	if self.velocity.x != 0:
		$AnimatedSprite2D.flip_h = self.velocity.x < 0
		
	move_and_slide()

func have_key() -> bool:
	return self.has_key

func pickup_key(node: Node2D) -> void:
	print("picking up a key")
	self.has_key = true
	node.queue_free()
	pass
