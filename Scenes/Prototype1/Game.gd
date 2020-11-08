extends Node2D

var chunks_filled  : Dictionary

var camera_offset : Vector2
var placing_structure : bool = false
var structure_placeable : bool = false
var structure_to_place : Area2D

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

var manual_constructor = preload("res://lib/manual_constructor/manual_constructor.tscn")
var manual_miner = preload("res://Components/Structures/ManualMiner/ManualMiner.tscn")

onready var camera : Camera2D = get_node("Camera")
onready var game_world : GameWorld = get_node("GameWorld")
onready var structure_hotkeys : Control = get_node("CanvasLayer/StructureHotkeys")
onready var warehouse := get_node("/root/Warehouse") as Warehouse
onready var warehouse_popup := get_node("CanvasLayer/Warehouse")


func _physics_process(_delta):
	if camera.just_moved:
		# In case we jump chunks
		ensure_chunks_filled()


func _process(_delta):
	if placing_structure:
		if Input.is_action_just_pressed("place_structure") and structure_placeable:
			warehouse.remove_item("Manual Miner")
			structure_hotkeys.set_manual_miner_count(
				warehouse.get_item_count("Manual Miner")
			)
			
			structure_to_place.resource_name = game_world.get_resource_name_at(
				structure_to_place.position.x / 32,
				structure_to_place.position.y / 32
			)
			
			placing_structure  = false
			structure_to_place = null
			
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			update_spawning_structure_placement()
	elif Input.is_action_just_pressed("spawn_miner") and warehouse.get_item_count("Manual Miner") > 0:
		placing_structure  = true
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
		structure_to_place = manual_miner.instance()
		update_spawning_structure_placement()
		
		self.add_child(structure_to_place)
	elif Input.is_action_just_pressed("open_warehouse"):
		if warehouse_popup.visible:
			warehouse_popup.hide()
		else:
			warehouse_popup.popup()


func _ready():
	# Set up RNG
	rng.randomize()
	
	# Start with some structures
	for _i in range(3):
		warehouse.add_item("Manual Miner")
	
	# Set up Structure counts
	structure_hotkeys.set_manual_miner_count(
		warehouse.get_item_count("Manual Miner")
	)
	
	# Save off starting camera position
	camera_offset = Vector2(
		camera.position.x,
		camera.position.y
	)

	# Fill visible chunks
	ensure_chunks_filled()


func ensure_chunks_filled():
	var chunk_size = game_world.get_chunk_size()
	var ground_cell_size = game_world.get_ground_cell_size()
	
	var camera_chunk_location = Vector2(
		floor((camera.position.x / ground_cell_size.x) / chunk_size.x),
		floor((camera.position.y / ground_cell_size.y) / chunk_size.y)
	)
	
	var viewport_size = get_viewport().size / ground_cell_size
	
	var x_chunks_per_viewport = ceil(viewport_size.x / chunk_size.x)
	var y_chunks_per_viewport = ceil(viewport_size.y / chunk_size.y)

	for chunk_x in range(camera_chunk_location.x - x_chunks_per_viewport, camera_chunk_location.x + x_chunks_per_viewport + 1):
		var x_chunks_filled = chunks_filled.get(chunk_x)

		if x_chunks_filled == null:
			x_chunks_filled = {}
			chunks_filled[chunk_x] = x_chunks_filled

		for chunk_y in range (camera_chunk_location.y - y_chunks_per_viewport, camera_chunk_location.y + y_chunks_per_viewport + 1):
			if !x_chunks_filled.get(chunk_y):
				game_world.generate_chunk(chunk_x, chunk_y)
				x_chunks_filled[chunk_y] = true


func update_spawning_structure_placement():
	var ground_cell_size = game_world.get_ground_cell_size()
	
	var world_mouse_position = get_viewport().get_mouse_position() + camera.position - camera_offset
	
	var spawn_cell_x = round(world_mouse_position.x / ground_cell_size.x)
	var spawn_cell_y = round(world_mouse_position.y / ground_cell_size.y)

	structure_to_place.position = Vector2(
		spawn_cell_x,
		spawn_cell_y
	) * ground_cell_size
	
	structure_placeable = game_world.has_resource_at(
		spawn_cell_x,
		spawn_cell_y
	)
	
	if structure_placeable:
		structure_to_place.modulate.a = 1.0
	else:
		structure_to_place.modulate.a = 0.3
