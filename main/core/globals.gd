extends Node

##########################
# Game
##########################

var spawn_rate: int = 5

const DEATH_HUNGER = 300
const BASE_HUNGER = 100
const HUNGER_THRESHOLD_1 = 60
const HUNGER_THRESHOLD_2 = 30

signal hunger_changed
var hunger: int = 100

func change_hunger(change_amount: int):
	hunger += change_amount
	if hunger >= DEATH_HUNGER:
		print("game over")
	
	hunger_changed.emit()

var money: int = 0

func add_money(money_to_add: int = 1):
	money += money_to_add
