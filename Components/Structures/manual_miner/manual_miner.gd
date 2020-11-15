class_name ManualMiner
extends Area2D

var item_name := "Manual Miner"
var resource_name := ""

onready var warehouse = get_node("/root/warehouse")


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT and resource_name != "":
		warehouse.add_item(resource_name)
