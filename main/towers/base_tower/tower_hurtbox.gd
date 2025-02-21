extends StaticBody2D
class_name TowerHurtbox

signal take_damage(damage: int)

func hit(damage: int):
	take_damage.emit(damage)
