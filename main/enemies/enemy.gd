extends RigidBody2D
class_name Enemy

@onready var health_component: HealthComponent = $HealthComponent

@export var target_object: Node2D
@export var speed: int = 100
@export var damage: int = 1

var hit_cooldown_timer: Timer

func _ready():
	hit_cooldown_timer = Timer.new()
	hit_cooldown_timer.autostart = false
	hit_cooldown_timer.wait_time = 1
	hit_cooldown_timer.one_shot = true
	add_child(hit_cooldown_timer)
	health_component.death.connect(_on_death)

func _physics_process(delta):
	var move_dir = (target_object.position - position).normalized()
	var bodies = get_colliding_bodies()
	if bodies.size() > 0:
		_on_tower_hit(bodies[0])
	
	move_and_collide(move_dir * delta * speed)

func _on_death():
	Globals.money += 1
	queue_free()
	
func _on_tower_hit(body: Node):
	if not hit_cooldown_timer.is_stopped():
		return

	var tower = body as TowerHurtbox
	tower.hit(damage)
	hit_cooldown_timer.start()
