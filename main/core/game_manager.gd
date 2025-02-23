extends Node2D

@export var core: Node2D
@export var enemy: PackedScene
@export var spawn_radius: float = 1000
@export var starting_money: int = 50
@export var start_delay: float = 5

var spawn_timer: Timer


func _ready():
	Globals.money = starting_money
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.one_shot = true
	spawn_timer.timeout.connect(_spawn_enemy)
	Globals.spawn_rate = 1
	spawn_timer.start(start_delay)

func _process(delta):
	Globals.spawn_rate += delta * 0.01
	
func _spawn_enemy():
	var node = enemy.instantiate() as Enemy
	add_child(node)
	node.target_object = core
	_spawn_randomly_on_circle(node, spawn_radius)
	spawn_timer.start(1.0 / Globals.spawn_rate)

func _spawn_randomly_on_circle(node: Node2D, radius: int):
	_spawn_on_circle(node, radius, randf_range(0, 2 * PI))


func _spawn_on_circle(node: Node2D, radius: int, angle: float):
	node.position = Vector2(radius * cos(angle), radius * sin(angle))
