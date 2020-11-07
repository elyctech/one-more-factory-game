extends Node2D

var chunk_size     : Vector2
var chunks_filled  : Dictionary
var ground_tiles   : Array
var resource_tiles : Array

var camera_offset       : Vector2
var placing_structure   : bool = false
var structure_placeable : bool = false
var structure_to_place  : Area2D

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

var manual_miner = preload("res://Components/Structures/ManualMiner/ManualMiner.tscn")

var items : Dictionary = {
	"ManualMiner" : 3
}

onready var camera            : Camera2D   = get_node("Camera")
onready var structure_hotkeys : Control    = get_node("CanvasLayer/StructureHotkeys")
onready var ground            : TileMap    = get_node("Ground")
onready var resources         : TileMap    = get_node("Resources")
onready var warehouse         : PopupPanel = get_node("CanvasLayer/Warehouse")


func _physics_process(_delta):
	if camera.just_moved:
		# In case we jump chunks
		ensure_chunks_filled()


func _process(_delta):
	if placing_structure:
		if Input.is_action_just_pressed("place_structure") and structure_placeable:
			items["ManualMiner"] -= 1
			structure_hotkeys.set_manual_miner_count(items["ManualMiner"])
			
			var cell_point = Vector2(
				structure_to_place.position.x / ground.cell_size.x - 0.5,
				structure_to_place.position.y / ground.cell_size.y - 0.5
			)
			
			var resource_name = resources.tile_set.tile_get_name(
				resources.get_cellv(cell_point)
			).capitalize()
			
			structure_to_place.resource_name = resource_name.substr(0, resource_name.length() - 1)
			
			warehouse.remove_item("Manual Miner")
			
			placing_structure  = false
			structure_to_place = null
			
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			update_spawning_structure_placement()
	elif Input.is_action_just_pressed("spawn_miner") and items.ManualMiner > 0:
		placing_structure  = true
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
		structure_to_place = manual_miner.instance()
		update_spawning_structure_placement()
		
		self.add_child(structure_to_place)
	elif Input.is_action_just_pressed("open_warehouse"):
		if warehouse.visible:
			warehouse.hide()
		else:
			warehouse.popup()


func _ready():
	# Set up RNG
	rng.randomize()
	
	# Set up Structure counts
	structure_hotkeys.set_manual_miner_count(items["ManualMiner"])
	
	for i in range(0, items["ManualMiner"]):
		warehouse.add_item("Manual Miner")
	
	# Set up tiles
	ground_tiles   = ground.tile_set.get_tiles_ids()
	resource_tiles = resources.tile_set.get_tiles_ids()
	
	# Set up chunks
	chunk_size = Vector2(20, 20)
	
	# Save off starting camera position
	camera_offset = Vector2(
		camera.position.x,
		camera.position.y
	)

	# Fill visible chunks
	ensure_chunks_filled()


func ensure_chunks_filled():
	var camera_chunk_location = Vector2(
		floor((camera.position.x / ground.cell_size.x) / chunk_size.x),
		floor((camera.position.y / ground.cell_size.y) / chunk_size.y)
	)
	
	var viewport_size = get_viewport().size / ground.cell_size
	
	var x_chunks_per_viewport = ceil(viewport_size.x / chunk_size.x)
	var y_chunks_per_viewport = ceil(viewport_size.y / chunk_size.y)

	for chunk_x in range(camera_chunk_location.x - x_chunks_per_viewport, camera_chunk_location.x + x_chunks_per_viewport + 1):
		var x_chunks_filled = chunks_filled.get(chunk_x)

		if x_chunks_filled == null:
			x_chunks_filled = {}
			chunks_filled[chunk_x] = x_chunks_filled

		for chunk_y in range (camera_chunk_location.y - y_chunks_per_viewport, camera_chunk_location.y + y_chunks_per_viewport + 1):
			if !x_chunks_filled.get(chunk_y):
				generate_chunk(chunk_x, chunk_y)
				x_chunks_filled[chunk_y] = true


func generate_chunk(chunk_x, chunk_y):
	var start_x = chunk_x * chunk_size.x
	var start_y = chunk_y * chunk_size.y
	
	for x in range(start_x, start_x + chunk_size.x):
		for y in range(start_y, start_y + chunk_size.y):
			# Add a ground tile
			ground.set_cell(x, y, ground_tiles[rng.randi_range(0, ground_tiles.size() - 1)])
			
			# Determine if a resource should be set (hard-coded 1% rate)
			if rng.randi_range(0, 99) == 0:
				resources.set_cell(x, y, resource_tiles[rng.randi_range(0, resource_tiles.size() - 1)])


func update_spawning_structure_placement():
	var spawn_point = get_viewport().get_mouse_position() + camera.position - camera_offset

	spawn_point = Vector2(
		round(spawn_point.x / ground.cell_size.x),
		round(spawn_point.y / ground.cell_size.y)
	) * ground.cell_size - ground.cell_size / 2
	
	structure_to_place.position = spawn_point
	
	var cell_point = Vector2(
		spawn_point.x / ground.cell_size.x - 0.5,
		spawn_point.y / ground.cell_size.y - 0.5
	)
	
	structure_placeable = resources.get_cellv(cell_point) > -1
	
	if structure_placeable:
		structure_to_place.modulate.a = 1.0
	else:
		structure_to_place.modulate.a = 0.3
