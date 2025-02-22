extends Area2D
class_name HealthComponent

signal death
signal knockback_force(direction: Vector2, force: float)

@export var max_health: float

var health: float

func _ready():
	health = max_health

func change_health(change_amount: float):
	health = min(health + change_amount, max_health)
	if health <= 0 or is_zero_approx(health):
		death.emit()

func knockback(direction: Vector2, force: float):
	knockback_force.emit(direction, force)
