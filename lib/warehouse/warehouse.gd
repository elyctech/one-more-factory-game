extends Node

signal item_count_changed

var _items : Dictionary = {}


func _ready():
	print(get_path())


func add_item(item_name, amount = 1):
	if _items.has(item_name):
		_items[item_name] += amount
	else:
		_items[item_name] = amount
	
	emit_signal("item_count_changed", item_name, _items[item_name])


func get_item_count(item_name):
	return _items[item_name]


func remove_item(item_name, amount = 1):
	# TODO Should not having the item be a warning or exception?
	if _items.has(item_name):
		if _items[item_name] < amount:
			# TODO Should this be a warning or exception?
			_items[item_name] = 0
		else:
			_items[item_name] -= amount
			
		emit_signal("item_count_changed", item_name, _items[item_name])
