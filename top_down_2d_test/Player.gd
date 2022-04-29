extends KinematicBody2D

export var speed = 169
export var max_health = 69

var surrounding_items = []
var surr_item_selected = 0;

func _ready():
	$AnimatedSprite.play()

func _process(delta):
	move(delta)
	pickup()

func _on_Pickup_body_entered(body):
	surrounding_items.append(body)
	print_debug(surrounding_items)

func _on_Pickup_body_exited(body):
	surrounding_items.remove(surrounding_items.find(body))
	print_debug(surrounding_items)
	
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
	
func pickup():
	if Input.is_action_pressed("pickup"):
		get_node(surrounding_items[surr_item_selected]).free()
