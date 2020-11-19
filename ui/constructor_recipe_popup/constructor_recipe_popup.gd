class_name ConstructorRecipePopup
extends PopupPanel

var constructor

var _active_recipe_item : Button
var _constructor_recipe_item = preload("res://ui/constructor_recipe_popup/constructor_recipe_item.tscn")

# TODO Move to autoload catalog?
var _recipes = {
	"Iron Ingot" : {
		"recipe_name" : "Iron Ingot",
		"ingredients" : {
			"Iron Ore" : 1
		},
	}
}

onready var _recipe_grid : GridContainer = get_node("ScrollContainer/Recipes")


func _ready():
	for recipe_name in _recipes:
		var item = _constructor_recipe_item.instance()
		item.text = recipe_name
		
		item.connect("selected", self, "_set_active_recipe")
		
		_recipe_grid.add_child(item)


func _set_active_recipe(recipe_name):
	# TODO Check for recipe existence
	if _active_recipe_item != null:
		_active_recipe_item.set_inactive()
	
	for recipe_item in _recipe_grid.get_children():
		if recipe_item.text == recipe_name:
			recipe_item.set_active()
			_active_recipe_item = recipe_item
	
	constructor.recipe = _recipes[recipe_name]
	self.hide()
