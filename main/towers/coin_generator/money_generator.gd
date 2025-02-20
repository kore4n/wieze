extends Node2D

@export var generate_interval: int = 5
@export var moeny_to_generate: int = 2

func _ready():
	var timer = Timer.new()
	timer.wait_time = generate_interval
	timer.one_shot = false
	timer.autostart = true
	timer.timeout.connect(_generate)
	add_child(timer)
	
func _generate():
	Globals.add_money(moeny_to_generate)
