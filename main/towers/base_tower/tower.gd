class_name Tower
extends Node2D

var is_placed = false

@onready var health_component: HealthComponent = $HealthComponent
@onready var tower_hurtbox: TowerHurtbox = $TowerHurtbox
@onready var placeable_area: Area2D = $PlaceableArea
@onready var tower_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var selectable_area_component: SelectableAreaComponent = $SelectableAreaComponent

func _ready():
	tower_sprite.play()
	tower_hurtbox.take_damage.connect(_on_tower_damage)
	health_component.death.connect(_on_tower_destroyed)
	selectable_area_component.selection_toggled.connect(func(s): print(str(s) + " " + name))
	tower_hurtbox.process_mode = Node.PROCESS_MODE_DISABLED

func _process(_delta) -> void:
	if is_placed == false:
		global_position = get_global_mouse_position()
		if can_be_placed():
			tower_sprite.modulate.a = 1
		else:
			tower_sprite.modulate.a = 0.5
		tower_sprite.flip_h = get_global_mouse_position().x < 0
	else:
		tower_hurtbox.process_mode = Node.PROCESS_MODE_INHERIT

func can_be_placed() -> bool:
	return placeable_area.get_overlapping_areas().size() == 0 and health_component.get_overlapping_bodies().size() == 0

func _on_tower_damage(damage: int):
	health_component.change_health(-damage)

func _on_tower_destroyed():
	queue_free()
