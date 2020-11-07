extends Control

var item_count : int = 0
var item_name  : String = ""

onready var item_count_label : Label = get_node("ItemCount")
onready var item_name_label  : Label = get_node("ItemName")


func _ready():
	item_name_label.text = item_name


func add_item():
	item_count += 1
	item_count_label.text = str(item_count)


func get_item_count():
	return item_count


func remove_item():
	item_count -= 1
	item_count_label.text = str(item_count)
