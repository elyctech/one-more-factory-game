class_name Warehouse
extends Node

signal item_count_changed

var _items : Dictionary = {}


func add_item(item_name, amount = 1):
	if _items.has(item_name):
		_items[item_name] += amount
	else:
		_items[item_name] = amount
	
	emit_signal("item_count_changed", item_name, _items[item_name])


func get_item_count(item_name):
	var item_count = 0
	
	if _items.has(item_name):
		item_count = _items[item_name]
	
	return item_count


func remove_item(item_name, amount = 1):
	# TODO Should not having the item be a warning or exception?
	if _items.has(item_name):
		if _items[item_name] < amount:
			# TODO Should this be a warning or exception?
			_items[item_name] = 0
		else:
			_items[item_name] -= amount
			
		emit_signal("item_count_changed", item_name, _items[item_name])
