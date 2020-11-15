class_name GroundLayer
extends Node2D

var _ground_tiles : Array

onready var _ground_tilemap : TileMap = get_node("Ground")

func _ready():
	_ground_tiles = _ground_tilemap.tile_set.get_tiles_ids()


func get_ground_cell_size():
	return _ground_tilemap.cell_size


func get_ground_tile_count():
	return _ground_tiles.size()


func set_cell(x, y, tile_index):
	_ground_tilemap.set_cell(x, y, _ground_tiles[tile_index])
