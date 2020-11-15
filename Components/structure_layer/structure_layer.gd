class_name StructureLayer
extends Node2D

var ground : GroundLayer
var resources : ResourceLayer

# TODO Not hardcode this?
var _structures := {
	"Manual Constructor": preload("res://components/structures/manual_constructor/manual_constructor.tscn"),
	"Manual Miner": preload("res://components/structures/manual_miner/manual_miner.tscn"),
}

var _placing_structure : bool
var _structure_placeable : bool
var _structure_to_place : Area2D
var _structures_placed : Dictionary

onready var _mouse : Mouse = get_node("/root/mouse")
onready var _warehouse : Warehouse = get_node("/root/warehouse")


func _process(_delta):
	if _placing_structure:
		if Input.is_action_just_pressed("place_structure"):
			_finish_placing_structure()
		else:
			_update_structure_preview()


func has_structure_at(cell_x, cell_y):
	var x_structures_placed = _structures_placed.get(cell_x)
	
	return x_structures_placed != null and x_structures_placed.get(cell_y) != null


func start_placing_structure(structure_name):
	var structure_scene = _structures.get(structure_name)
	
	# TODO Throw error if null
	if structure_scene != null:
		# Create an instance, place it where it needs to be, then add it to the world
		_structure_to_place = structure_scene.instance()
		_update_structure_preview()
		self.add_child(_structure_to_place)
		
		# Enter placing structure mode
		_placing_structure = true
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _finish_placing_structure():
	# TODO throw an error if the structure is not placeable
	if _structure_placeable:
		var resource_cell_size = resources.get_resource_cell_size()
		
		var cell_x = _structure_to_place.position.x / resource_cell_size.x
		var cell_y = _structure_to_place.position.y / resource_cell_size.y
		
		# If the structure is a miner, set up what resource is being mined
		if _structure_to_place is ManualMiner:
			_structure_to_place.resource_name = resources.get_resource_name_at(
				cell_x,
				cell_y
			)
		
		# Register this cell as taken
		var x_structures_placed = _structures_placed.get(cell_x)
		
		if x_structures_placed == null:
			_structures_placed[cell_x] = {
				cell_y : true
			}
		else:
			x_structures_placed[cell_y] = true
		
		# Remove the structure count from the warehouse
		_warehouse.remove_item(_structure_to_place.item_name)
		
		# Clear the structure being placed
		_structure_to_place = null
		
		# Exit placing structure mode
		_placing_structure  = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _update_structure_preview():
	var ground_cell_size = ground.get_ground_cell_size()
	
	# Get the current cell
	var spawn_cell = _mouse.get_hovered_cell(ground_cell_size)
	
	# Move the structure to the current cell
	_structure_to_place.position = spawn_cell * ground_cell_size
	
	# Check if a structure is at the cell
	_structure_placeable = !has_structure_at(
		spawn_cell.x,
		spawn_cell.y
	)
	
	if _structure_placeable:
		# If the structure is a miner, make sure even if the spot is open there
		# is a resource to mine
		if _structure_to_place is ManualMiner:
			_structure_placeable = resources.has_resource_at(
				spawn_cell.x,
				spawn_cell.y
			)
		# If the structure is not a miner, make sure even if the spot is open there
		# is not a resource in that spot
		elif _structure_to_place is ManualConstructor:
			_structure_placeable = !resources.has_resource_at(
				spawn_cell.x,
				spawn_cell.y
			)
	
	# Set the transparency based on placeability
	if _structure_placeable:
		_structure_to_place.modulate.a = 1.0
	else:
		_structure_to_place.modulate.a = 0.3
