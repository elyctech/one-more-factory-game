class_name Mouse
extends Node

var camera : GameCamera


func get_hovered_cell(cell_size : Vector2):
	var mouse_position = get_viewport().get_mouse_position() + camera.get_world_position()
	
	return Vector2(
		round(mouse_position.x / cell_size.x),
		round(mouse_position.y / cell_size.y)
	)
