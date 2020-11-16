extends Control

var menu_container;

var controls_menu : Control = preload("res://Components/InGameMenu/Controls/Controls.tscn").instance()


func _on_controls_pressed():
	menu_container.change_menu(controls_menu)
