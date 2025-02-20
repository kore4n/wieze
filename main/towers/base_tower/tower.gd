class_name Tower

extends Node2D

var is_placed = false

@onready var placeable_area: Area2D = $PlaceableArea
@onready var tower_sprite: Sprite2D = $Sprite2D

func _process(_delta) -> void:
	if is_placed == false:
		global_position = get_global_mouse_position()
		if can_be_placed():
			tower_sprite.modulate.a = 1
		else:
			tower_sprite.modulate.a = 0.5

func can_be_placed() -> bool:
	return placeable_area.get_overlapping_areas().size() == 0
