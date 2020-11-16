class_name ResourceLayer
extends Node2D

var _resource_tiles : Array

# TODO Do not hard-code this?
var _resource_names := {
	"coal1" : "Coal",
	"coal2" : "Coal",
	"coal3" : "Coal",
	"copper1" : "Copper Ore",
	"copper2" : "Copper Ore",
	"copper3" : "Copper Ore",
	"iron1" : "Iron Ore",
	"iron2" : "Iron Ore",
	"iron3" : "Iron Ore"
}

onready var _resource_tilemap : TileMap = get_node("Resources")


func _ready():
	_resource_tiles = _resource_tilemap.tile_set.get_tiles_ids()


func get_resource_cell_size():
	return _resource_tilemap.cell_size


func get_resource_name_at(cell_x, cell_y):
	var tile_name = _resource_tilemap.tile_set.tile_get_name(
		_resource_tilemap.get_cell(
			cell_x,
			cell_y
		)
	)
	
	var resource_name = ""
	
	# TODO Should not having this tile be an error or warning?
	if _resource_names.has(tile_name):
		resource_name = _resource_names[tile_name]
	
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
