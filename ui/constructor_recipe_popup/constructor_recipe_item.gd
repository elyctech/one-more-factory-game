extends Button

signal selected


func set_active():
	self.disabled = true


func set_inactive():
	self.disabled = false


func _on_pressed():
	self.emit_signal("selected", self.text)
