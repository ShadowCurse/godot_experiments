extends CharacterBody2D

@export var cursor: Node2D
@export var starting_weapon: PackedScene

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

var weapons: Array = []
var current_weapon: int = 0

func setup_camera(map_limits: Rect2i, map_cellsize: Vector2, map_scale: Vector2) -> void:
	$Camera2D.limit_left = map_limits.position.x * map_cellsize.x * map_scale.x
	$Camera2D.limit_right = map_limits.end.x * map_cellsize.x * map_scale.x
	$Camera2D.limit_top = map_limits.position.y * map_cellsize.y * map_scale.y
	$Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y * map_scale.y

func setup_weapons() -> void:
	var w = starting_weapon.instantiate()
	self.weapons.append(w)
	self.current_weapon = 0;
	self.add_child(w)
	$CanvasLayer/UI.select_sword()

func _process(delta: float) -> void:
	if Input.is_action_pressed("attack"):
		self.weapons[self.current_weapon].attack(self.position, self.cursor.position)
	if Input.is_action_just_pressed("weapon1"):
		if self.switch_weapons(0):
			$CanvasLayer/UI.select_sword()
	if Input.is_action_just_pressed("weapon2"):
		if self.switch_weapons(1):
			$CanvasLayer/UI.select_crossbow()

func switch_weapons(weapon_slot: int) -> bool:
	if self.weapons.size() <= weapon_slot:
		return false
	self.current_weapon = weapon_slot;
	return true

func _physics_process(delta: float) -> void:
	match controls_type:
		Controls.TopDown:
			self.physics_process_top_down(delta)
		Controls.SideScroll:
			self.physics_process_side_scroll(delta)
	
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
	self.move_and_slide()
	
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

func pickup_key() -> void:
	print("picking up a key")
	self.has_key = true
	pass

func pickup_weapon(weapon: PackedScene) -> void:
	var w = weapon.instantiate()
	self.weapons.append(w)
	self.add_child(w)
	$CanvasLayer/UI.add_crossbow()
