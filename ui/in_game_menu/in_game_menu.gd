extends Control

var menu_container;

var controls_menu : Control = preload("res://ui/in_game_menu/controls/controls.tscn").instance()


func _on_controls_pressed():
	menu_container.change_menu(controls_menu)
