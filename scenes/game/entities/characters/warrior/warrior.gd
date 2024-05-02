extends CharacterBody2D
class_name Warrior

const SPEED = 50

enum states {
	Idle,
	Walk,
	Attack,
	Death,
	GetHit,
}

var Hp = 100
var current_state = states.Idle
var direction
var _body
var body_exited
var target

func _ready():
	if randf() < 0.5:
		direction = -1
	else:
		direction = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation = $AnimatedSprite2D
@onready var attack_zone = $Zones/AttackZone


func _physics_process(delta):
	match current_state:
		states.Idle:
			velocity.x = 0;
			if not is_on_floor():
				current_state = states.Walk
			animation.play("idle")
			
		states.Walk:
			animation.play("run")
			if not is_on_floor():
				velocity.y += gravity * delta
				
			if target != null && target.position.x < position.x:
				direction = -1
			else: 
				direction = 1
				
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)

			if direction > 0:
				animation.set_flip_h(false)
				attack_zone.set_scale(Vector2(1,1))
			elif direction < 0:
				animation.set_flip_h(true)
				attack_zone.set_scale(Vector2(-1,1))
				
		states.Attack:
			if _body != null:
				velocity.x = 0;
				animation.play("attack")
				if animation.get_frame() == 9:
					attack_zone.set_monitoring(true)
				elif animation.get_frame() == 11:
					attack_zone.set_monitoring(false)
				
		states.GetHit:
			attack_zone.set_monitoring(false)
			animation.play("take_hit")
			if Hp <= 0:
				current_state = states.Death
			
		states.Death:
			attack_zone.set_monitoring(false)
			animation.play("death")
			
	$Label.set_text(states.keys()[current_state])			
	move_and_slide()


func _on_watch_zone_body_entered(body):
	body_exited = false
	current_state = states.Walk
	_body = body
	target = body


func _on_watch_zone_body_exited(body):
	body_exited = true
	current_state = states.Idle
	target = null
