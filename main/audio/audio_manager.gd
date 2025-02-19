extends Node

@onready var music_player = $MusicPlayer

@export_range(0, 1, 0.01) var music_volume = 0.5
@export_range(0, 1, 0.01) var sfx_volume = 0.5

var music = AudioServer.get_bus_index("Music")
var sfx = AudioServer.get_bus_index("SFX")


func _ready():
	AudioServer.set_bus_volume_linear(music, music_volume)
	AudioServer.set_bus_volume_linear(sfx, sfx_volume)

func play_sound(stream: AudioStream, parent: Node = self):
	var instance = AudioStreamPlayer2D.new()
	instance.stream = stream
	instance.finished.connect(_remove_node.bind(instance))
	instance.bus = sfx
	parent.add_child(instance)
	instance.play()

func _remove_node(instance: AudioStreamPlayer2D):
	instance.queue_free()
