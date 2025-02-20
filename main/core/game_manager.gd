extends Node2D

@export var core: Node2D
@export var enemy: PackedScene
@export var spawn_radius: float = 1000

var spawn_timer: Timer


func _ready():
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.wait_time = 1
	spawn_timer.start()
	spawn_timer.timeout.connect(_spawn_enemy)
	
	
func _spawn_enemy():
	var node = enemy.instantiate() as Enemy
	add_child(node)
	node.target_object = core
	_spawn_randomly_on_circle(node, spawn_radius)


func _spawn_randomly_on_circle(node: Node2D, radius: int):
	_spawn_on_circle(node, radius, randf_range(0, 2 * PI))


func _spawn_on_circle(node: Node2D, radius: int, angle: float):
	node.position = Vector2(radius * cos(angle), radius * sin(angle))
