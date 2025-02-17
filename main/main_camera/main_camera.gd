extends Camera2D

const MIN_ZOOM: float = 0.1
const MAX_ZOOM: float = 0.5
const ZOOM_INCREMENT: float = 0.1
const ZOOM_RATE: float = 8.0

@onready var target_zoom: float = zoom.x

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if (event.button_index == MOUSE_BUTTON_WHEEL_UP):
				zoom_in()
			if (event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
				zoom_out()
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
			global_position -= event.relative / zoom

func zoom_out() -> void:
	target_zoom = max(target_zoom - ZOOM_INCREMENT, MIN_ZOOM)
	set_physics_process(true)
	
func zoom_in() -> void:
	target_zoom = min(target_zoom + ZOOM_INCREMENT, MAX_ZOOM)
	set_physics_process(true)
	
func _physics_process(delta: float) -> void:
	zoom = lerp(
		zoom,
		target_zoom * Vector2.ONE,
		ZOOM_RATE * delta
	)
	set_physics_process(
		not is_equal_approx(zoom.x, target_zoom)
	)
