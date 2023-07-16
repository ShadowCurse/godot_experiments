extends CharacterBody2D

@export var cursor: Node2D
@export var starting_weapon: PackedScene

const SPEED = 200.0
const JUMP = -444.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(delta: float) -> void:
	var cursor_pos = get_global_mouse_position()
	var direction = cursor_pos - self.position
	self.rotation = direction.angle()
	pass

func _physics_process(delta: float) -> void:
	self.physics_process_top_down(delta)
	
func setup_camera(map_limits: Rect2i, map_cellsize: Vector2, map_scale: Vector2) -> void:
	$Camera2D.limit_left = map_limits.position.x * map_cellsize.x * map_scale.x
	$Camera2D.limit_right = map_limits.end.x * map_cellsize.x * map_scale.x
	$Camera2D.limit_top = map_limits.position.y * map_cellsize.y * map_scale.y
	$Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y * map_scale.y
	
func physics_process_top_down(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		self.velocity.x = direction.x * SPEED
		self.velocity.y = direction.y * SPEED
	else:
		self.velocity.x = move_toward(self.velocity.x, 0, SPEED)
		self.velocity.y = move_toward(self.velocity.y, 0, SPEED)

	self.move_and_slide()
