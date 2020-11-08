class_name GameWorld
extends Node2D

export var chunk_size : Vector2 = Vector2(20, 20)
export var resource_rate : float = 0.01

var _rng : RandomNumberGenerator = RandomNumberGenerator.new()

var _ground_tiles   : Array
var _resource_tiles : Array

onready var _ground_tilemap : TileMap = get_node("Ground")
onready var _resources_tilemap : TileMap = get_node("Resources")


func _ready():
	# Set up tiles
	_ground_tiles = _ground_tilemap.tile_set.get_tiles_ids()
	_resource_tiles = _resources_tilemap.tile_set.get_tiles_ids()


func generate_chunk(chunk_x, chunk_y):
	# Find starting tiles
	var start_x = chunk_x * chunk_size.x
	var start_y = chunk_y * chunk_size.y
	
	for x in range(start_x, start_x + chunk_size.x):
		for y in range(start_y, start_y + chunk_size.y):
			# Add a ground tile
			_ground_tilemap.set_cell(x, y, _ground_tiles[_rng.randi_range(0, _ground_tiles.size() - 1)])
			
			# Determine if a resource should be set (hard-coded 1% rate)
			if _rng.randi_range(0, 99) == 0:
				_resources_tilemap.set_cell(x, y, _resource_tiles[_rng.randi_range(0, _resource_tiles.size() - 1)])


func get_chunk_size():
	return chunk_size


func get_ground_cell_size():
	return _ground_tilemap.cell_size


func get_resource_name_at(cell_x, cell_y):
	var resource_name = _resources_tilemap.tile_set.tile_get_name(
		_resources_tilemap.get_cell(
			cell_x,
			cell_y
		)
	).capitalize()
	
	resource_name = resource_name.substr(0, resource_name.length() - 1)
	
	return resource_name


func has_resource_at(cell_x, cell_y):
	return _resources_tilemap.get_cell(
		cell_x,
		cell_y
	) > -1
