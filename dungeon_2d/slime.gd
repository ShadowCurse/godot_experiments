extends CharacterBody2D

@export var speed: float = 30.0
@export var patrol_path: PathFollow2D

var previous_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	$AnimatedSprite2D.play("run")

func _physics_process(delta: float) -> void:
	patrol_path.progress = (patrol_path.progress + speed * delta)
	self.previous_pos = self.position
	self.position = patrol_path.position
	var direction = previous_pos - self.position
	if direction.x != 0:
		$AnimatedSprite2D.flip_h = direction.x > 0
