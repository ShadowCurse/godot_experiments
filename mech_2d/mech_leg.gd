extends Node2D

@export var torso: Node2D
@export var leg_side: LegSide
@export var leg_length: float
@export var max_angle: float
@export var min_angle: float
@export var torso_offset: float = 5.0

enum LegSide {
	FrontRight,
	FrontLeft,
	BackRight,
	BackLeft,
}

var current_position: Vector2
var new_position: Vector2
var position_transition: float = 0.0
var position_transition_speed: float = 20.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.move_leg()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = anchor_to_leg_vector()
	var distance = direction.length()
	var leg_angle = torso_forward().angle_to(direction)
	print("side: ", self.leg_side, " angle: ", rad_to_deg(leg_angle))
	
	if self.position_transition <= 1.0:
		self.move_to_new_position(delta)
	
	self.rotation = -1.5 * PI + direction.angle() 
	
	if self.leg_length < distance:
		self.move_leg()
		print("distance: ", distance)
	if leg_angle < deg_to_rad(min_angle) || deg_to_rad(max_angle) < leg_angle:
		print("angle...........")
		self.move_leg()
		
	var torso_pos_in_local = self.to_local(anchor_position())
	$Line2D.set_point_position(1, torso_pos_in_local)
	
	print("torso_forward: ", torso_forward())
#	$Line2D.set_point_position(0, self.to_local(self.torso.position))
#	$Line2D.set_point_position(1, self.to_local(self.torso.position + torso_forward() * 100.0))

func leg_to_anchor_offset() -> Vector2:
	var max_side = self.leg_length * 0.1
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

func leg_position() -> Vector2:
	return self.torso.to_global(self.anchor_to_torso_offset() + self.leg_to_anchor_offset())

func move_leg() -> void:
	var direction = anchor_to_leg_vector()
	
	self.rotation = -1.5 * PI + direction.angle()
	
	self.current_position = self.position
	self.new_position = leg_position()
	self.position_transition = 0.0
	
func move_to_new_position(delta: float) -> void:
	self.position_transition += self.position_transition_speed * delta
	self.position = lerp(self.current_position, self.new_position, self.position_transition)
	
