extends Node2D
class_name CoreKing

@onready var shoot_timer: Timer = $ShootTimer
@onready var tax_timer: Timer = $TaxTimer
@onready var eat_timer: Timer = $EatTimer
@onready var hunger_drain_timer: Timer = $HungerDrainTimer
@onready var shoot_area: Area2D = $ShootArea

@export var base_damage: int = 1
@export var shoot_speed: float = 1
@export var hunger_drain_rate: int = 1
@export var projectile: PackedScene

var fire_speed_multiplier: float = 1
var damage_multiplier: float = 1
var knockback_force: float = 0

const TAX_WAIT_TIME = 1
const EAT_WAIT_TIME = 10

enum HungerState {Happy, Hungry, Starving}
var state = HungerState.Happy


func _ready():
	Globals.hunger = Globals.BASE_HUNGER
	Globals.hunger_changed.connect(_on_hunger_changed)
	state = HungerState.Happy
	
	tax_timer.wait_time = TAX_WAIT_TIME
	eat_timer.wait_time = EAT_WAIT_TIME
	shoot_timer.wait_time = 1 / shoot_speed
	shoot_timer.timeout.connect(_shoot)
	tax_timer.timeout.connect(_tax)
	eat_timer.timeout.connect(_eat)
	hunger_drain_timer.timeout.connect(_drain_hunger)
	EventBus.tower_sacrifice.connect(_buff_king)

func _drain_hunger():
	Globals.hunger -= hunger_drain_rate

func _on_hunger_changed():
	var hunger = Globals.hunger
	if hunger > Globals.HUNGER_THRESHOLD_1:
		state = HungerState.Happy
		tax_timer.stop()
		eat_timer.stop()
	elif hunger > Globals.HUNGER_THRESHOLD_2:
		state = HungerState.Hungry
		if tax_timer.is_stopped():
			tax_timer.start()
		eat_timer.stop()
	else:
		state = HungerState.Starving
		if eat_timer.is_stopped():
			eat_timer.start()

func _shoot():
	var target = _get_closest_target()
	if not target: return
	
	var proj = projectile.instantiate() as KingProjectile
	proj.damage = base_damage * damage_multiplier
	proj.knockback_force = knockback_force
	add_child(proj)
	proj.direction = (target.position - position).normalized()
	
	# Update shoot speed
	shoot_timer.wait_time =  1 / (shoot_speed * fire_speed_multiplier)
	if state != HungerState.Happy:
		shoot_timer.wait_time /= 2
	
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
	Globals.money -= roundi(Globals.spawn_rate * TAX_WAIT_TIME)
	
func _eat():
	Globals.break_n_towers(Globals.global_towers.size() / 3)

func _on_hurtbox_body_entered(body: Node2D):
	Globals.hunger += 10
	body.queue_free()

func _buff_king(tower_type: Globals.TowerType, tower: Tower):
	match tower_type:
		Globals.TowerType.Orchard:
			fire_speed_multiplier += 0.2
		Globals.TowerType.Tofu:
			damage_multiplier += 0.2
		Globals.TowerType.Catapult:
			knockback_force += 20
			
	Globals.break_tower(tower)
