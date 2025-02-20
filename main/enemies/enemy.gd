extends RigidBody2D
class_name Enemy

@onready var health_component: HealthComponent = $HealthComponent

@export var target_object: Node2D
@export var speed: int = 100
@export var damage: int = 1

var is_hitting_object = false
var hit_object: HealthComponent
var hit_timer: Timer

func _ready():
	health_component.area_entered.connect(_on_area_entered)
	health_component.area_exited.connect(_on_area_exited)
	hit_timer = Timer.new()
	hit_timer.autostart = false
	hit_timer.wait_time = 1
	add_child(hit_timer)
	hit_timer.timeout.connect(_hit_object)
	health_component.death.connect(_on_death)
	
func _process(delta):
	position = position.move_toward(target_object.position, delta * speed)

func _physics_process(delta):
	var move_dir = (target_object.position - position).normalized()
	move_and_collide(move_dir * delta * speed)

func _on_death():
	Globals.money += 1
	queue_free()
	
func _hit_object():
	hit_object.change_health(-damage)

func _on_area_entered(area: Area2D):
	var hc = area as HealthComponent
	is_hitting_object = true
	hit_timer.start()
	
func _on_area_exited(area: Area2D):
	is_hitting_object = false
	hit_timer.stop()
