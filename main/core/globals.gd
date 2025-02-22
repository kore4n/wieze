extends Node

##########################
# Game
##########################

enum TowerType {
	Orchard,
	Tofu,
	Catapult
}

var spawn_rate: int = 5

const DEATH_HUNGER = 300
const BASE_HUNGER = 100
const HUNGER_THRESHOLD_1 = 60
const HUNGER_THRESHOLD_2 = 30

signal hunger_changed
signal game_over
var hunger: int = 100:
	set = _set_hunger
	
func _set_hunger(value):
	hunger = value
	if hunger >= DEATH_HUNGER:
		game_over.emit()
	hunger_changed.emit()

var money: int = 0:
	set(value):
		money_changed.emit()
		money = max(value, 0)
signal money_changed

var global_towers: Array[Tower] = []

func track_tower(tower: Tower):
	global_towers.append(tower)
	
func break_tower(tower: Tower):
	global_towers.remove_at(global_towers.find(tower))
	tower.destroy()
	if hunger < BASE_HUNGER:
		hunger = min(hunger + 5, BASE_HUNGER)
	
func break_n_towers(n: int):
	var size = global_towers.size()
	if size < n:
		return

	for i in range(n):
		var idx = randi_range(0, size - 1 - i)
		break_tower(global_towers[idx])
		if hunger < BASE_HUNGER:
			hunger = min(hunger + 5, BASE_HUNGER)
