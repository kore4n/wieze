extends Node2D

func _ready():
	get_tree().create_timer(5).timeout.connect(func(): queue_free())

func _process(delta):
	modulate.a -= delta / 5
	position += delta * 20 * Vector2.UP
