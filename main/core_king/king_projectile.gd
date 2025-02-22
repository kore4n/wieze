extends Node2D
class_name KingProjectile

@onready var area_2d: Area2D = $Area2D

@export var damage: float = 1
@export var direction: Vector2
@export var speed: float = 300
@export var max_lifetime: float = 30
@export var knockback_force: float = 1

func _ready():
	area_2d.area_entered.connect(_on_area_entered)
	var timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(func (): queue_free())
	timer.start(max_lifetime)
	
func _process(delta):
	position += direction * speed * delta
	
func _on_area_entered(area: Area2D):
	var health_component = area as HealthComponent
	health_component.change_health(-damage)
	if knockback_force > 0:
		health_component.knockback(direction, knockback_force)
	queue_free()
