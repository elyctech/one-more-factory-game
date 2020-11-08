extends PopupPanel

var _item_controls : Dictionary = {}

var item_control_scene = preload("res://Components/Warehouse/WarehouseItem.tscn")

onready var item_container : GridContainer = get_node("ScrollContainer/Items")


func _ready():
	get_node("/root/Warehouse").connect("item_count_changed", self, "update_item_count")


func update_item_count(item_name, item_count):
	if _item_controls.has(item_name):
		_item_controls[item_name].set_item_count(item_count)
	else:
		var item_control = item_control_scene.instance()
		item_control.item_name = item_name
		
		_item_controls[item_name] = item_control
		
		item_container.add_child(item_control)
		
		item_control.set_item_count(item_count)
