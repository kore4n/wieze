extends CanvasLayer

@onready var hunger_label1 = $Control/Label
@onready var hunger_label2 = $Control/Label2

func _ready():
	Globals.hunger_changed.connect(_on_hunger_changed)
	hunger_label1.visible = false
	hunger_label2.visible = false
	
func _on_hunger_changed():
	var hunger = Globals.hunger
	if hunger > Globals.HUNGER_THRESHOLD_1:
		hunger_label1.visible = false
		hunger_label2.visible = false
	elif hunger > Globals.HUNGER_THRESHOLD_2:
		hunger_label1.visible = true
		hunger_label2.visible = false
	else:
		hunger_label1.visible = true
		hunger_label2.visible = true
