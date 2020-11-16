class_name GameCamera
extends Camera2D

var just_moved : bool = false

var _move_speed : int = 300
var _movement : Vector2 = Vector2(0, 0)
var _sqrt_half : float = sqrt(0.5)

var _world_offset : Vector2


func _ready():
	_world_offset = self.position


func _physics_process(delta):
	if _movement.length() > 0:
		var magnitude = delta * _move_speed;
		
		self.position.x += _movement.x * magnitude
		self.position.y += _movement.y * magnitude
		
		just_moved = true
	elif just_moved:
		just_moved = false


func _process(_delta):
	_process_input()


func get_world_position():
	return self.position - get_viewport().size / 2


func _process_input():
	var move_x = false
	var move_y = false
	var x_direction = 0
	var y_direction = 0
	
	var move_down = Input.is_action_pressed("move_down")
	var move_left = Input.is_action_pressed("move_left")
	var move_right = Input.is_action_pressed("move_right")
	var move_up = Input.is_action_pressed("move_up")
	
	if move_right and !move_left:
		move_x = true
		x_direction = 1
	elif move_left and !move_right:
		move_x = true
		x_direction = -1

	if move_down and !move_up:
		move_y = true
		y_direction = 1
	elif move_up and !move_down:
		move_y = true
		y_direction = -1
	
	# If moving in both directions
	if move_x and move_y:
		# Set each component magnitude so the full magnitude is 1
		_movement.x = x_direction * _sqrt_half
		_movement.y = y_direction * _sqrt_half
	else:
		# Otherwise, direction variables will determine which way to move
		_movement.x = x_direction
		_movement.y = y_direction
