extends Node2D

var chunks_filled  : Dictionary

onready var _camera : GameCamera = get_node("Camera")
onready var _constructor_recipe_popup := get_node("CanvasLayer/ConstructorRecipePopup")
onready var _game_world : GameWorld = get_node("GameWorld")
onready var _mouse : Mouse = get_node("/root/mouse")
onready var _structure_hotkeys : Control = get_node("CanvasLayer/StructureHotkeys")
onready var _warehouse : Warehouse = get_node("/root/warehouse")
onready var _warehouse_popup := get_node("CanvasLayer/Warehouse")


func _physics_process(_delta):
	if _camera.just_moved:
		# In case we jump chunks
		_ensure_chunks_filled()


func _process(_delta):
	if Input.is_action_just_pressed("hotkey1") and _warehouse.get_item_count("Manual Miner") > 0:
		_game_world.start_placing_structure(
			"Manual Miner"
		)
	elif Input.is_action_just_pressed("hotkey2") and _warehouse.get_item_count("Manual Constructor") > 0:
		_game_world.start_placing_structure(
			"Manual Constructor"
		)
	elif Input.is_action_just_pressed("open_warehouse"):
		if _warehouse_popup.visible:
			_warehouse_popup.hide()
		else:
			_warehouse_popup.popup()


func _ready():
	# TODO change to set_camera - lifecycle is not as expected
	# Set up mouse
	_mouse.camera = _camera
	
	# Set up game world
	_game_world.set_constructor_recipe_popup(_constructor_recipe_popup)
	
	# Start with some structures
	_warehouse.add_item("Manual Miner", 3)
	_warehouse.add_item("Manual Constructor")
	
	# Fill visible chunks
	_ensure_chunks_filled()


func _ensure_chunks_filled():
	var chunk_size = _game_world.get_chunk_size()
	var ground_cell_size = _game_world.get_ground_cell_size()
	
	var camera_chunk_location = Vector2(
		floor((_camera.position.x / ground_cell_size.x) / chunk_size.x),
		floor((_camera.position.y / ground_cell_size.y) / chunk_size.y)
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
				_game_world.generate_chunk(chunk_x, chunk_y)
				x_chunks_filled[chunk_y] = true
