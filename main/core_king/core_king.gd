extends Node2D
class_name CoreKing

@onready var shoot_timer: Timer = $ShootTimer
@onready var tax_timer: Timer = $TaxTimer
@onready var eat_timer: Timer = $EatTimer
@onready var hunger_drain_timer: Timer = $HungerDrainTimer
@onready var shoot_area: Area2D = $ShootArea

@export var base_damage: int = 1
@export var shoot_speed: int = 1
@export var hunger_drain_rate: int = 1
@export var projectile: PackedScene

const TAX_WAIT_TIME = 5
const EAT_WAIT_TIME = 10

enum HungerState {Happy, Hungry, Starving}
var state = HungerState.Happy


func _ready():
	Globals.hunger = Globals.BASE_HUNGER
	Globals.hunger_changed.connect(_on_hunger_changed)
	state = HungerState.Happy
	
	tax_timer.wait_time = TAX_WAIT_TIME
	eat_timer.wait_time = EAT_WAIT_TIME
	shoot_timer.timeout.connect(_shoot)
	tax_timer.timeout.connect(_tax)
	eat_timer.timeout.connect(_eat)
	hunger_drain_timer.timeout.connect(_drain_hunger)

func _drain_hunger():
	Globals.change_hunger(-hunger_drain_rate)

func _on_hunger_changed():
	var hunger = Globals.hunger
	if hunger > Globals.HUNGER_THRESHOLD_1:
		state = HungerState.Happy
		tax_timer.stop()
		eat_timer.stop()
		shoot_timer.wait_time = shoot_speed
	elif hunger > Globals.HUNGER_THRESHOLD_2:
		state = HungerState.Hungry
		tax_timer.start()
		eat_timer.stop()
		shoot_timer.wait_time = shoot_speed * 2
	else:
		state = HungerState.Starving
		eat_timer.start()
		shoot_timer.wait_time = shoot_speed * 2

func _shoot():
	var target = _get_closest_target()
	if not target: return
	
	var proj = projectile.instantiate() as KingProjectile
	proj.damage = base_damage
	add_child(proj)
	proj.direction = (target.position - position).normalized()
	
func _get_closest_target():
	var targets = shoot_area.get_overlapping_bodies()
	if len(targets) == 0: return
	
	var target = targets[0]
	var dist_squared = (position - target.position).dot(position - target.position)
	for t in targets:
		var d = position - t.position
		d = d.dot(d)
		if d < dist_squared:
			target = t
			dist_squared = d
	return target
	
func _tax():
	Globals.add_money(-roundi(Globals.spawn_rate * TAX_WAIT_TIME * 1.5))
	
func _eat():
	pass

func _on_hurtbox_body_entered(body: Node2D):
	Globals.change_hunger(5)
	body.queue_free()
