extends Camera2D

var just_moved : bool    = false
var move_speed : int     = 300
var movement   : Vector2 = Vector2(0, 0)
var sqrt_half  : float   = sqrt(0.5)


func _physics_process(delta):
	if movement.length() > 0:
		var magnitude = delta * move_speed;

		self.position.x += movement.x * magnitude
		self.position.y += movement.y * magnitude
		
		just_moved = true
	elif just_moved:
		just_moved = false


func _process(_delta):
	process_input()


func process_input():
	var move_x      = false
	var move_y      = false
	var x_direction = 0
	var y_direction = 0
	
	var move_down  = Input.is_action_pressed("move_down")
	var move_left  = Input.is_action_pressed("move_left")
	var move_right = Input.is_action_pressed("move_right")
	var move_up    = Input.is_action_pressed("move_up")
	
	if move_right and !move_left:
		move_x      = true
		x_direction = 1
	elif move_left and !move_right:
		move_x      = true
		x_direction = -1

	if move_down and !move_up:
		move_y      = true
		y_direction = 1
	elif move_up and !move_down:
		move_y      = true
		y_direction = -1
	
	# If moving in both directions
	if move_x and move_y:
		# Set each component magnitude so the full magnitude is 1
		movement.x = x_direction * sqrt_half
		movement.y = y_direction * sqrt_half
	else:
		# Otherwise, direction variables will determine which way to move
		movement.x = x_direction
		movement.y = y_direction
