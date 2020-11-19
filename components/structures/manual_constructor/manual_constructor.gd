class_name ManualConstructor
extends Area2D

signal recipe_change_requested

var item_name := "Manual Constructor"
var recipe

var _interaction_response := preload("res://ui/interaction_response/interaction_response.tscn")
var _last_construction := 0
# TODO Limit this per-recipe
var _construction_rate := 500

onready var warehouse = get_node("/root/warehouse")


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_RIGHT:
			self.emit_signal("recipe_change_requested", self)
		elif event.button_index == BUTTON_LEFT and recipe != null:
			if OS.get_ticks_msec() - _last_construction >= _construction_rate:
				var can_make = true
				
				for ingredient in recipe.ingredients:
					if warehouse.get_item_count(ingredient) < recipe.ingredients[ingredient]:
						can_make = false
						break
				
				var construction_response = _interaction_response.instance()
				
				if can_make:
					for ingredient in recipe.ingredients:
						warehouse.remove_item(ingredient, recipe.ingredients[ingredient])
					
					warehouse.add_item(recipe.recipe_name)
					
					construction_response.text = "+1 %s" % recipe.recipe_name
				else:
					construction_response.text = "Not enough ingredients"
					
				self.add_child(
					construction_response
				)
				
				_last_construction = OS.get_ticks_msec()
