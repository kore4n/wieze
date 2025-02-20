extends Area2D
class_name HealthComponent

signal death

@export var max_health: int

var health: int

func _ready():
	health = max_health

func change_health(change_amount: int):
	health = min(health + change_amount, max_health)
	if health <= 0:
		death.emit()
