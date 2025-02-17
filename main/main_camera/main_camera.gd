extends Camera2D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
			var mouse_delta = event.relative
			position -= mouse_delta / zoom
