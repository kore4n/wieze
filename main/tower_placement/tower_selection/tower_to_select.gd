extends Node

@export var tower_to_spawn_prefab: PackedScene

func _on_button_button_down() -> void:
	EventBus.on_player_selected_tower.emit(tower_to_spawn_prefab)
