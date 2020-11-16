extends Control

onready var warehouse : Warehouse = get_node("/root/warehouse")

onready var structure_counts = {
	"Manual Constructor" : get_node("ManualConstructorCount"),
	"Manual Miner" : get_node("ManualMinerCount")
}


func _ready():
	var _error = warehouse.connect("item_count_changed", self, "_update_structure_count")


func _update_structure_count(item_name, item_count):
	if structure_counts.has(item_name):
		structure_counts[item_name].text = str(item_count)
