extends Area2D
class_name AppleProjectile

@export var speed: int = 1000
@export var max_lifetime: float = 30

var damage: int
var direction: Vector2

func _ready():
	area_entered.connect(_on_area_entered)
	var timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(func (): queue_free())
	timer.start(max_lifetime)
	look_at(direction)

func _process(delta):
	position += direction * delta * speed

func _on_area_entered(area: Area2D):
	var health_component = area as HealthComponent
	health_component.change_health(-damage)
	queue_free()
