extends RigidBody2D
class_name Enemy

@export var target_object: Node2D
@export var speed: int = 100
@export var health: int = 1
@export var damage: int = 1


func _process(delta):
	position = position.move_toward(target_object.position, delta * speed)

func _physics_process(delta):
	var move_dir = (target_object.position - position).normalized()
	move_and_collide(move_dir * delta * speed)

func take_damage(damage_taken: int):
	health -= damage_taken
	if health <= 0:
		_on_death()


func _on_death():
	Globals.money += 1
	queue_free()


func _on_body_entered(body):
	pass # Replace with function body.
