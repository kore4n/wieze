extends Area2D
class_name SelectableAreaComponent

signal selection_toggled(selection)

@export var exclusive = true

var selected = false:
	set = set_selected
	
func set_selected(selection):
	if selection:
		_make_exclusive()
		add_to_group("selected")
	else:
		remove_from_group("selected")
	selected = selection
	emit_signal("selection_toggled", selected)
		
func _make_exclusive():
	if not exclusive:
		return
	get_tree().call_group("selected", "set_selected", false)
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		set_selected(not selected)
