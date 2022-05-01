extends KinematicBody2D

signal health_change(new_hp)

export var speed = 100
export var max_health = 100

var hp = max_health

func _ready():
	emit_signal("health_change", hp)
	$AnimatedSprite.play()

func _process(delta):
	move(delta)
	take_damage(5)
	
func move(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.animation = "run"
	else:
		$AnimatedSprite.animation = "idle"
	
	if velocity.x < 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
	
	move_and_slide(velocity * speed * delta)
	
func take_damage(damage):
	# for testing purpuse
	if Input.is_action_pressed("pickup"):
		hp -= damage
		print("Hp left: ", hp)
		emit_signal("health_change", hp)
