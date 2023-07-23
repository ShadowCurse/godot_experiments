extends Node2D

# signal to move a leg with some id
signal move(int)

@export var mech: Node2D
@export var radius: float = 5.0 

enum MovementType {
	Move,
	Rotate,
	None
}

var move_order: Array
var rotate_order: Array
var next_to_move: int
var movement_type: MovementType

var last_mech_transform: Transform2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.position = mech.position
	self.move_order = [0, 2, 1, 3]
	self.rotate_order = [0, 1, 2, 3]
	self.next_to_move = 0
	self.movement_type = MovementType.None

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (self.mech.position - self.position).length() > self.radius:
		self.position = self.mech.position
		self.move_legs()
		
	if abs(self.rotation_degrees - self.mech.rotation_degrees) > 50.0:
		self.rotation = self.mech.rotation
		self.rotate_legs()
		
	if self.last_mech_transform != self.mech.get_transform():
		$reset_timer.start()
		self.last_mech_transform = self.mech.get_transform()
		
	self.queue_redraw()
		
func _draw() -> void:
	draw_circle(Vector2(0.0, 0.0), self.radius, Color.RED)
		
func move_legs() -> void:
	if self.movement_type == MovementType.None:
		self.movement_type = MovementType.Move
		self.move.emit(self.move_order[self.next_to_move])
	
func rotate_legs() -> void:
	if self.movement_type == MovementType.None:
		self.movement_type = MovementType.Rotate
	self.move.emit(self.rotate_order[self.next_to_move])
		
func on_leg_moved() -> void:
	self.next_to_move = self.next_to_move + 1
	if self.next_to_move == self.move_order.size():
		self.next_to_move = 0
		self.movement_type = MovementType.None
	else:
		match self.movement_type:
			MovementType.Move:
				self.move.emit(self.move_order[self.next_to_move])
			MovementType.Rotate:
				self.move.emit(self.rotate_order[self.next_to_move])

func _on_reset_timer_timeout() -> void:
	self.rotate_legs()
