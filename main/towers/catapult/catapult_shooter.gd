extends Node2D

@onready var shoot_area = $ShootArea
@onready var apple_animated_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"

@export var projectile_scene: PackedScene
@export var damage: int = 2
@export var shoot_interval: float = 1.2
@export var apple_idle_frames: SpriteFrames
@export var apple_shoot_frames: SpriteFrames

func _shoot_loop():
	await get_tree().create_timer(shoot_interval).timeout
	var target = _get_closest_target()
	if target:
		var proj: AppleProjectile = projectile_scene.instantiate()
		proj.damage = damage
		add_child(proj)
		proj.direction = (target.position - global_position).normalized()
		proj.look_at(target.global_position)
	else:
		apple_animated_sprite.sprite_frames = apple_idle_frames
	apple_animated_sprite.play()
	_shoot_loop()
	
func _get_closest_target() -> Node2D:
	var targets = shoot_area.get_overlapping_bodies()
	if len(targets) == 0: return
	
	var target = targets[0]
	var dist_squared = (global_position - target.position).dot(global_position - target.position)
	for t in targets:
		var d = global_position - t.position
		d = d.dot(d)
		if d < dist_squared:
			target = t
			dist_squared = d
	return target
