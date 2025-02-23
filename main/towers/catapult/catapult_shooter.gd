extends Node2D

@onready var shoot_area = $ShootArea

@export var projectile_scene: PackedScene
@export var damage: int = 2

func _ready():
	var timer = Timer.new()
	timer.autostart = true
	timer.one_shot = false
	timer.wait_time = 2
	timer.timeout.connect(_shoot)
	add_child(timer)

func _shoot():
	var target = _get_closest_target()
	if not target: return
	
	var proj = projectile_scene.instantiate()
	proj.damage = damage
	add_child(proj)
	proj.direction = (target.position - global_position).normalized()
	
func _get_closest_target():
	var targets = shoot_area.get_overlapping_bodies()
	if len(targets) == 0: return
	
	var target = targets[0]
	var dist_squared = (global_position - target.position).dot(global_position - target.position)
	for t in targets:
		var d = global_position - t.position
		d = d.dot(d)
		if d < dist_squared:
			target = t
			dist_squared = d
	return target
