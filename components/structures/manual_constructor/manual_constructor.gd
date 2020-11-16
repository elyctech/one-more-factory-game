class_name ManualConstructor
extends Area2D

var item_name := "Manual Constructor"
var recipe


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_RIGHT:
			print("Select recipe")
			recipe = "Manual Miner"
		elif event.button_index == BUTTON_LEFT and recipe != null:
			print("Constructing %s" % recipe)
