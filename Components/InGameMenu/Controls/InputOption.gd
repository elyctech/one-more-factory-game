extends Button

var key               : String = ""
var listening_for_key : bool   = false

export var action : String = ""


func _input(event):
	# Listen for key input when resetting a binding
	if listening_for_key and event is InputEventKey:
		get_tree().set_input_as_handled()

		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)

		listening_for_key = false

		# Enable controls while done changing controls
		var scene = get_tree().current_scene

		if scene.has_method("enable_controls"):
			scene.enable_controls()

		refresh_key_text()


func _ready():
	refresh_key_text()


func _on_pressed(event):
	if event is InputEventMouseButton and event.pressed == false:
		# Pressing while listening cancels the edit
		if listening_for_key:
			self.text = key
			listening_for_key = false
		else:
			# Right-click clears the control
			if event.button_index == BUTTON_RIGHT:
				InputMap.action_erase_events(action)
				key = ""
				self.text = ""
			# All other clicks activate editing the control
			else:
				# Disable controls while changing controls
				var scene = get_tree().current_scene

				if scene.has_method("disable_controls"):
					scene.disable_controls()

				listening_for_key = true
				self.text = "..."


func refresh_key_text():
	key = InputMap.get_action_list(action)[0].as_text()
	self.text = key
