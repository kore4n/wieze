extends Node2D

@export var generate_interval: int = 5
@export var money_to_generate: int = 2
@export var coin_vfx: PackedScene

func _ready():
	var timer = Timer.new()
	timer.wait_time = generate_interval
	timer.one_shot = false
	timer.autostart = true
	timer.timeout.connect(_generate)
	add_child(timer)
	
func _generate():
	Globals.money += money_to_generate
	var inst = coin_vfx.instantiate()
	add_child(inst)
	inst.position = Vector2(0, -100)
