class_name InteractionResponse
extends Label

var lift_rate := 50
var time_to_live := 0.5

var _time_alive := 0.0

func _physics_process(delta):
	self.rect_position.y -= lift_rate * delta
	_time_alive += delta
	
	if _time_alive >= time_to_live:
		self.queue_free()
