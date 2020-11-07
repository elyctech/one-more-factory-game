extends Node2D

var resource_name := ""

onready var warehouse = get_node("/root/Game/CanvasLayer/Warehouse")


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT and resource_name != "":
		warehouse.add_item(resource_name)
