extends ProgressBar

func _ready():
	max_value = Globals.BASE_HUNGER
	value = max_value
	Globals.hunger_changed.connect(_on_hunger_changed)
	
func _on_hunger_changed():
	value = Globals.hunger
