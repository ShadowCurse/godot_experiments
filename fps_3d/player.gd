extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSE = 0.8

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var main_camera = $Camera3D
@onready var gun_viewport = $Camera3D/SubViewportContainer/SubViewport
@onready var gun_camera = $Camera3D/SubViewportContainer/SubViewport/Camera3D

func _ready() -> void:
	gun_viewport.size = get_window().size
	
func _process(delta: float) -> void:
	gun_camera.global_transform = main_camera.global_transform
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func _input(event):
	if event is InputEventMouseMotion:
		self.rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSE))
		main_camera.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSE))
		main_camera.rotation.x = clamp(main_camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
