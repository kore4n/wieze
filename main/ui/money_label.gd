extends Label

func _ready():
	Globals.money_changed.connect(_on_money_changed)
	_on_money_changed()
	
func _on_money_changed():
	text = "${money}".format({ "money": Globals.money })
