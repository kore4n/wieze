extends Node2D

@onready var ground_tile_map: TileMapLayer = $GroundTileMapLayer
@onready var highlight_tile_map: TileMapLayer = $HighlightTileMapLayer
@onready var tower_tile_map: TileMapLayer = $TowerTileMapLayer

@export
var tower_dict: Dictionary[Vector2i, String]

func _ready() -> void:
	var used_cell_positions: Array[Vector2i] = tower_tile_map.get_used_cells()
	for used_cell_position in used_cell_positions:
		tower_dict[used_cell_position] = 'used hereeee'

func _process(_delta):
	var hovered_tile_position: Vector2i = tower_tile_map.local_to_map(get_global_mouse_position())
	
	for selected_cell in highlight_tile_map.get_used_cells():
		highlight_tile_map.erase_cell(selected_cell)
		
	if (!ground_tile_map.get_cell_tile_data(hovered_tile_position)):
		return
		
	if !tower_dict.has(hovered_tile_position):
		highlight_tile_map.set_cell(hovered_tile_position, 0, Vector2i.ZERO)
