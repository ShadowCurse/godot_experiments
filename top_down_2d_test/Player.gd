extends KinematicBody2D

signal health_change(new_hp)

export var speed = 150
export var max_health = 100
export var friction = 0.5

var velocity = Vector2.ZERO

var hp = max_health

func _ready():
	emit_signal("health_change", hp)
	$AnimatedSprite.play()

func _process(delta):
	animation()
	take_damage(5)
	
func _physics_process(delta):
	var direction = Vector2.ZERO
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1
	
	direction.normalized()
	velocity += direction * speed;
	
	velocity = move_and_slide(velocity)
	velocity = lerp(velocity, Vector2.ZERO, friction)
	
func animation():
	if velocity.length() > 0.1:
		$AnimatedSprite.animation = "run"
	else:
		$AnimatedSprite.animation = "idle"
	
	var mouse_dir = (get_global_mouse_position() - global_position).normalized()
	if mouse_dir.x < 0:
		$AnimatedSprite.flip_h = true
		$Sword.scale.x = -1.0
	else:
		$AnimatedSprite.flip_h = false
		$Sword.scale.x = 1.0
	
func take_damage(damage):
	# for testing purpuse
	if Input.is_action_pressed("pickup"):
		hp -= damage
		print("Hp left: ", hp)
		emit_signal("health_change", hp)
