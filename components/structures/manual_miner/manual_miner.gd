class_name ManualMiner
extends Area2D

var item_name := "Manual Miner"
var resource_name := ""

var _interaction_response := preload("res://ui/interaction_response/interaction_response.tscn")
var _last_mining := 0
var _mining_rate := 500

onready var warehouse = get_node("/root/warehouse")


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if resource_name != "" and OS.get_ticks_msec() - _last_mining >= _mining_rate:
			warehouse.add_item(resource_name)
			
			var mining_response = _interaction_response.instance()
			mining_response.text = "+1 %s" % resource_name
					
			self.add_child(
				mining_response
			)
			
			_last_mining = OS.get_ticks_msec()
