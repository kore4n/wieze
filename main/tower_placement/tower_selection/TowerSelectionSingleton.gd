extends Node

var draggable_tower_to_place: Tower = null

func _ready() -> void:
	EventBus.connect("on_player_selected_tower", handle_player_selected_tower)

func handle_player_selected_tower(tower_to_spawn_prefab: PackedScene) -> void:
	draggable_tower_to_place = tower_to_spawn_prefab.instantiate()
	get_tree().root.add_child(draggable_tower_to_place)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and draggable_tower_to_place != null:
		if draggable_tower_to_place.can_be_placed():
			Globals.place_tower(draggable_tower_to_place)
		else:
			draggable_tower_to_place.queue_free()
		draggable_tower_to_place = null
