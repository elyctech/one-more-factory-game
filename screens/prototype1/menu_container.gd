extends Control

var current_menu : Control;

func change_menu(new_menu):
	if current_menu:
		remove_child(current_menu)
	
	current_menu = new_menu
	add_child(new_menu)

func close_menu():
	if current_menu:
		remove_child(current_menu)
		current_menu = null
