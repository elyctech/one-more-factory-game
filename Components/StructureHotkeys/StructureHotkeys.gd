extends Control

var manual_miner_text = "Manual Miner (%s)"

onready var manual_miner : Label = get_node("ManualMiner")


func _ready():
	set_manual_miner_count(0)


func set_manual_miner_count(count):
	manual_miner.text = manual_miner_text % str(count)
