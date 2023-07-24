extends Node2D

signal leg_moved

enum LegSide {
	FrontRight,
	FrontLeft,
	BackRight,
	BackLeft,
}

@export var torso: Node2D
@export var leg_id: int
@export var leg_side: LegSide

var leg_length: float = 40.0
var torso_offset: float = 20.0
var current_position: Vector2
var new_position: Vector2
var position_transition: float = 0.0
var position_transition_speed: float = 20.0
var reset_time: float = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.move_leg(Vector2(0.0, 0.0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = anchor_to_leg_vector()
	var distance = direction.length()
	var leg_angle = torso_forward().angle_to(direction)
	self.rotation = -1.5 * PI + direction.angle() 
	
	# if transition to new pos is not finished
	# contine movement
	if self.position_transition <= 1.0:
		self.move_to_new_position(delta)
		
#	var torso_pos_in_local = self.to_local(anchor_position())
#	$Line2D.set_point_position(1, torso_pos_in_local)

func leg_to_anchor_offset() -> Vector2:
	var max_side = self.leg_length * 0.5
	var offset: Vector2
	match self.leg_side:
		LegSide.FrontRight:
			offset = Vector2(max_side, max_side)
		LegSide.FrontLeft:
			offset = Vector2(max_side, -max_side)
		LegSide.BackRight:
			offset = Vector2(-max_side, max_side)
		LegSide.BackLeft:
			offset = Vector2(-max_side, -max_side)
	return offset
	
func anchor_to_torso_offset() -> Vector2:
	var max_side = self.torso_offset
	var offset: Vector2
	match self.leg_side:
		LegSide.FrontRight:
			offset = Vector2(max_side, max_side)
		LegSide.FrontLeft:
			offset = Vector2(max_side, -max_side)
		LegSide.BackRight:
			offset = Vector2(-max_side, max_side)
		LegSide.BackLeft:
			offset = Vector2(-max_side, -max_side)
	return offset

func anchor_position() -> Vector2:
	return self.torso.to_global(self.anchor_to_torso_offset())

func anchor_to_leg_vector() -> Vector2:
	return self.position - anchor_position()

func torso_forward() -> Vector2:
	return (self.torso.to_global(Vector2.RIGHT) - self.torso.position).normalized()

func leg_position(offset: Vector2) -> Vector2:
	return self.torso.to_global(self.anchor_to_torso_offset() + self.leg_to_anchor_offset()) + offset

func move_leg(offset: Vector2) -> void:
	var direction = anchor_to_leg_vector()
	self.rotation = -1.5 * PI + direction.angle()
	self.current_position = self.position
	self.new_position = leg_position(offset)
	self.position_transition = 0.0
	$AnimationPlayer.play("move", -1, self.position_transition_speed)
	
func move_to_new_position(delta: float) -> void:
	self.position_transition += self.position_transition_speed * delta
	self.position = lerp(self.current_position, self.new_position, self.position_transition)
	if self.position_transition >= 1.0:
		self.leg_moved.emit()

func _on_move_signal(id: int, offset: Vector2) -> void:
	print("leg move", id, offset)
	if id == self.leg_id:
		self.move_leg(offset)
