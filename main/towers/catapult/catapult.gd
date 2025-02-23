extends Tower

@onready var catapult_shooter = $CatapultShooter
	
func place():
	super()
	catapult_shooter._shoot_loop()
