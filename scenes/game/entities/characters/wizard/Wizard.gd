extends CharacterBody2D
class_name Wizard

const SPEED = 50

enum states {
	Idle,
	Walk,
	Attack,
	Death,
	GetHit,
}

var current_state = states.Walk
var _body
var one_fireball_instance_bool = false # для того, чтобы выпускался только 1 фаэрбол
var direction
var body_exited = false # вышел ли игрок из зоны поражения
var FireBall = preload("res://scenes/game/entities/characters/wizard/fire_ball.tscn")
var Hp = 100


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	if randf() < 0.5:
		direction = -1
	else:
		direction = 1

@onready var animation = $AnimatedSprite2D
@onready var muzzle = $Mazzle
@onready var attack_zone = $HitZones/WatchZone
@onready var walk_timer = $WalkTimer
@onready var take_hit_area = $HitBoxes/TakeHitArea

func _physics_process(delta):
	match current_state:
		states.Idle:
			velocity.x = 0;
			if not is_on_floor():
				current_state = states.Walk
			animation.play("idle")
			
		states.Walk:
			$Label2.set_text(str(direction))
			animation.play("walk")
			if not is_on_floor():
				velocity.y += gravity * delta
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)

			if direction > 0:
				animation.set_flip_h(false)
				muzzle.position.x = abs(muzzle.position.x)
				attack_zone.set_scale(Vector2(1,1))
			elif direction < 0:
				animation.set_flip_h(true)
				muzzle.position.x = -muzzle.position.x
				attack_zone.set_scale(Vector2(-1,1))
				
		states.Attack:
			if _body != null:
				velocity.x = 0;
				animation.play("attack")
				if animation.get_frame() == 8 and !one_fireball_instance_bool:
					one_fireball_instance_bool = true
					attack_char(_body)
				
		states.GetHit:
			attack_zone.set_monitoring(false)
			animation.play("take_hit")
			if Hp <= 0:
				current_state = states.Death
			
		states.Death:
			attack_zone.set_monitoring(false)
			take_hit_area.set_monitorable(false)
			animation.play("death")
			
	$Label.set_text(states.keys()[current_state])			
	move_and_slide()

func attack_char(body):
	if body != null:
		walk_timer.stop();
		print("I see you %s" % body.name)
		var fireball = FireBall.instantiate()
		fireball.set_position(muzzle.get_global_position())
		fireball.set_target(body)
		get_parent().add_child(fireball)

func _on_watch_zone_body_entered(body):
	body_exited = false
	current_state = states.Attack
	_body = body
	
func _on_animated_sprite_2d_animation_finished():
	if current_state == states.Death:
		queue_free()
	if current_state == states.GetHit:
		attack_zone.set_monitoring(true)
		current_state = states.Idle
	one_fireball_instance_bool = false
	if body_exited:
		walk_timer.start()
		current_state = states.Idle
	else:
		animation.play("attack")


func _on_walk_timer_timeout():
	print("Timer is out")
	if current_state == states.Walk:
		current_state = states.Idle
		if direction >= 0:
			direction = -1
		else:
			direction = 1
	elif current_state == states.Idle:
		current_state = states.Walk
	
func take_hit(value:):
	print("Wizard take hit by %s" % value)
	
	Hp -= value;
	current_state = states.GetHit

func _on_watch_zone_body_exited(body):
	body_exited = true;
