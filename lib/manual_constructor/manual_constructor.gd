extends Area2D

var recipe


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_RIGHT:
			print("Select recipe")
			recipe = "ManualMiner"
		elif event.button_index == BUTTON_LEFT and recipe != null:
			print("Constructing %s" % recipe)
