extends Node2D

var chunk_size    : Vector2
var chunks_filled : Dictionary
var dirt_tiles    : Array

var controls_enabled : bool                  = true
var move_speed       : int                   = 300
var movement         : Vector2               = Vector2(0, 0)
var rng              : RandomNumberGenerator = RandomNumberGenerator.new()
var sqrt_half        : float                 = sqrt(0.5)

onready var camera  : Camera2D = get_node("Camera2D")
onready var tilemap : TileMap  = get_node("TileMap")


func _input(event):
	if controls_enabled and event is InputEventKey:
		var move_x      = false
		var move_y      = false
		var x_direction = 0
		var y_direction = 0
		
		if Input.is_action_just_pressed("move_right") or Input.is_action_just_released("move_left"):
			move_x      = true
			x_direction = 1
		elif Input.is_action_just_pressed("move_left") or Input.is_action_just_released("move_right"):
			move_x      = true
			x_direction = -1
		elif Input.is_action_just_pressed("move_down") or Input.is_action_just_released("move_up"):
			move_y      = true
			y_direction = 1
		elif Input.is_action_just_pressed("move_up") or Input.is_action_just_released("move_down"):
			move_y      = true
			y_direction = -1
		
		if move_x:
			# If already moving in X, must be moving right
			if movement.x != 0:
				# Cancel X movement
				movement.x = 0

				# If also moving in Y, reset Y magnitude to 1 in the necessary direction
				if movement.y != 0:
					movement.y /= abs(movement.y)
			# If not moving in X but moving in Y
			elif movement.y != 0:
				# Set each component magnitude so the full magnitude is 1
				movement.x = x_direction * sqrt_half
				movement.y = sign(movement.y) * sqrt_half
			# If not moving at all
			else:
				movement.x = x_direction
		elif move_y:
			# If already moving in Y, must be moving up
			if movement.y != 0:
				# Cancel Y movement
				movement.y = 0

				# If also moving in X, reset X magnitude to 1 in the necessary direction
				if movement.x:
					movement.x /= abs(movement.x)
			# If not moving in Y but moving in X
			elif movement.x != 0:
				# Set each component magnitude so the full magnitude is 1
				movement.x = sign(movement.x) * sqrt_half
				movement.y = y_direction * sqrt_half
			# If not moving at all
			else:
				# Set the magnitude to 1
				movement.y = y_direction


func _physics_process(delta):
	if movement.length() > 0:
		var magnitude = delta * move_speed;

		camera.position.x += movement.x * magnitude
		camera.position.y += movement.y * magnitude
		
		# In case we jump chunks
		ensure_chunks_filled()


func _ready():
	# Set up RNG
	rng.randomize()
	
	# Set up tiles
	var tileset = tilemap.tile_set

	dirt_tiles = [
		tileset.find_tile_by_name("dirt1"),
		tileset.find_tile_by_name("dirt2"),
		tileset.find_tile_by_name("dirt3")
	]
	
	# Set up chunks
	chunk_size = Vector2(20, 20)

	ensure_chunks_filled()


func disable_controls():
	controls_enabled = false


func enable_controls():
	controls_enabled = true


func ensure_chunks_filled():
	var camera_chunk_location = Vector2(
		floor((camera.position.x / tilemap.cell_size.x) / chunk_size.x),
		floor((camera.position.y / tilemap.cell_size.y) / chunk_size.y)
	)
	
	var viewport_size = get_viewport().size / tilemap.cell_size
	
	var x_chunks_per_viewport = ceil(viewport_size.x / chunk_size.x)
	var y_chunks_per_viewport = ceil(viewport_size.y / chunk_size.y)

	for chunk_x in range(camera_chunk_location.x - x_chunks_per_viewport, camera_chunk_location.x + x_chunks_per_viewport + 1):
		var x_chunks_filled = chunks_filled.get(chunk_x)

		if x_chunks_filled == null:
			x_chunks_filled = {}
			chunks_filled[chunk_x] = x_chunks_filled

		for chunk_y in range (camera_chunk_location.y - y_chunks_per_viewport, camera_chunk_location.y + y_chunks_per_viewport + 1):
			if !x_chunks_filled.get(chunk_y):
				generate_tiles(chunk_x, chunk_y)
				x_chunks_filled[chunk_y] = true


func generate_tiles(chunk_x, chunk_y):
	var start_x = chunk_x * chunk_size.x
	var start_y = chunk_y * chunk_size.y
	
	for x in range(start_x, start_x + chunk_size.x):
		for y in range(start_y, start_y + chunk_size.y):
			tilemap.set_cell(x, y, dirt_tiles[rng.randi_range(0, 2)])
