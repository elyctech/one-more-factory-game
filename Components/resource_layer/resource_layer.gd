class_name ResourceLayer
extends Node2D

var _resource_tiles : Array

onready var _resource_tilemap : TileMap = get_node("Resources")


func _ready():
	_resource_tiles = _resource_tilemap.tile_set.get_tiles_ids()


func get_resource_cell_size():
	return _resource_tilemap.cell_size


func get_resource_name_at(cell_x, cell_y):
	# Tiles are named "<resource><version>", so get the resource name from the
	# tile at the desired location and capitalize it
	var resource_name = _resource_tilemap.tile_set.tile_get_name(
		_resource_tilemap.get_cell(
			cell_x,
			cell_y
		)
	).capitalize()
	
	# Strip the number. Currently, there are only single digits, so we assume
	# we can strip just the last character.
	resource_name = resource_name.substr(0, resource_name.length() - 1)
	
	return resource_name


func get_resource_tile_count():
	return _resource_tiles.size()


func has_resource_at(cell_x, cell_y):
	return _resource_tilemap.get_cell(
		cell_x,
		cell_y
	) > -1


func set_cell(x, y, tile_index):
	_resource_tilemap.set_cell(x, y, _resource_tiles[tile_index])
