extends PopupPanel

var items : Dictionary = {}

var item_control_scene = preload("res://Components/Warehouse/WarehouseItem.tscn")

onready var item_container : GridContainer = get_node("ScrollContainer/Items")

func add_item(item_name):
	var item_control
	
	if items.has(item_name):
		item_control = items[item_name]
	else:
		item_control = item_control_scene.instance()
		item_control.item_name = item_name
		items[item_name] = item_control
		item_container.add_child(item_control)
	
	item_control.add_item()


func get_item_count(item_name):
	var item_count := 0
	
	if items.has(item_name):
		item_count = items[item_name].get_item_count()
	
	return item_count


func remove_item(item_name):
	if items.has(item_name):
		items[item_name].remove_item()
	
