class_name Tower
extends Node2D

var is_placed = false

@export var tower_type: Globals.TowerType
@export var cost: int

@onready var highlight: Rectangle2D = $Highlight
@onready var health_component: HealthComponent = $HealthComponent
@onready var tower_hurtbox: TowerHurtbox = $TowerHurtbox
@onready var placeable_area: Area2D = $PlaceableArea
@onready var tower_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var selectable_area_component: SelectableAreaComponent = $SelectableAreaComponent
@onready var feed_button: Button = $Highlight/Button

func _ready():
	tower_sprite.play()
	tower_hurtbox.take_damage.connect(_on_tower_damage)
	health_component.death.connect(_on_death)
	tower_hurtbox.process_mode = Node.PROCESS_MODE_DISABLED
	highlight.visible = false
	feed_button.pressed.connect(_feed_to_king)

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

func place():
	is_placed = true

func can_be_placed() -> bool:
	return placeable_area.get_overlapping_areas().size() == 0 and health_component.get_overlapping_bodies().size() == 0 and Globals.money >= cost

func _on_tower_damage(damage: int):
	health_component.change_health(-damage)

func _on_death():
	Globals.break_tower(self)

func destroy():
	queue_free()

func _on_selectable_area_component_selection_toggled(selection):
	highlight.visible = selection
	
func _feed_to_king():
	EventBus.tower_sacrifice.emit(tower_type, self)
