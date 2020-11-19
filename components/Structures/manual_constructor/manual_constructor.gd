class_name ManualConstructor
extends Area2D

signal recipe_change_requested

var item_name := "Manual Constructor"
var recipe

onready var warehouse = get_node("/root/warehouse")


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_RIGHT:
			self.emit_signal("recipe_change_requested", self)
		elif event.button_index == BUTTON_LEFT and recipe != null:
			var can_make = true
			
			for ingredient in recipe.ingredients:
				if warehouse.get_item_count(ingredient) < recipe.ingredients[ingredient]:
					can_make = false
					break
			
			if can_make:
				for ingredient in recipe.ingredients:
					warehouse.remove_item(ingredient, recipe.ingredients[ingredient])
				
				warehouse.add_item(recipe.recipe_name)
