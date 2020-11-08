extends Control

var item_name  : String = ""

onready var _item_count_label : Label = get_node("ItemCount")
onready var _item_name_label : Label = get_node("ItemName")


func _ready():
	_item_name_label.text = item_name


func set_item_count(item_count):
	_item_count_label.text = str(item_count)
