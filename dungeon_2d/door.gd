extends Area2D

signal opened

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if (body.have_key()):
		self.start_openning()

func start_openning() -> void:
	$AnimatedSprite2D.play()

func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.animation = "open"
	$DoorCollider/CollisionShape2D.set_deferred("disabled", true)
	opened.emit()
