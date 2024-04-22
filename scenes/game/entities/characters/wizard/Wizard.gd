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
var one_fireball_instance_bool = false
var direction
var body_exited = false
var FireBall = preload("res://scenes/game/entities/characters/wizard/fire_ball.tscn")


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
			print(muzzle.get_position())	
			if direction > 0:
				animation.set_flip_h(false)
				muzzle.position.x = abs(muzzle.position.x)
				attack_zone.set_scale(Vector2(1,1))
			elif direction < 0:
				animation.set_flip_h(true)
				muzzle.position.x = -muzzle.position.x
				attack_zone.set_scale(Vector2(-1,1))
		states.Attack:
			velocity.x = 0;
			animation.play("attack")
			if animation.get_frame() == 8 and !one_fireball_instance_bool:
				one_fireball_instance_bool = true
				attack_char(_body)
	$Label.set_text(states.keys()[current_state])			
	move_and_slide()

func attack_char(body):
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
	one_fireball_instance_bool = false
	if body_exited:
		current_state = states.Idle
	else:
		animation.play("attack")


func _on_walk_timer_timeout():
	if current_state == states.Walk:
		current_state = states.Idle
		if direction >= 0:
			direction = -1
		else:
			direction = 1
	elif current_state == states.Idle:
		current_state = states.Walk
	


func _on_watch_zone_body_exited(body):
	body_exited = true;
