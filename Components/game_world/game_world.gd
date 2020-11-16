class_name GameWorld
extends Node2D

var _chunk_size : Vector2 = Vector2(20, 20)
var _resource_rate : float = 0.001

var _rng : RandomNumberGenerator = RandomNumberGenerator.new()

onready var _ground_layer : GroundLayer = get_node("GroundLayer")
onready var _resource_layer : ResourceLayer = get_node("ResourceLayer")
onready var _structure_layer : StructureLayer = get_node("StructureLayer")


func _ready():
	# Set up structure layer
	_structure_layer.ground = _ground_layer
	_structure_layer.resources = _resource_layer


func generate_chunk(chunk_x, chunk_y):
	# Find starting tiles
	var start_x = chunk_x * _chunk_size.x
	var start_y = chunk_y * _chunk_size.y
	
	for x in range(start_x, start_x + _chunk_size.x):
		for y in range(start_y, start_y + _chunk_size.y):
			# Add a ground tile
			_ground_layer.set_cell(x, y, _rng.randi_range(0, _ground_layer.get_ground_tile_count() - 1))
			
			# Determine if a resource should be set (hard-coded 1% rate)
			if _rng.randi_range(0, 1 / _resource_rate) == 0:
				_resource_layer.set_cell(x, y, _rng.randi_range(0, _resource_layer.get_resource_tile_count() - 1))


func get_chunk_size():
	return _chunk_size


func get_ground_cell_size():
	return _ground_layer.get_ground_cell_size()


func start_placing_structure(structure_name):
	# Delegate to the structure layer
	_structure_layer.start_placing_structure(structure_name)
