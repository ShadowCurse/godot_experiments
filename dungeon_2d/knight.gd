extends CharacterBody2D

const SPEED = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var has_key: bool = false

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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

func have_key() -> bool:
	return self.has_key

func pickup_key(node: Node2D) -> void:
	print("picking up a key")
	self.has_key = true
	node.queue_free()
	pass
