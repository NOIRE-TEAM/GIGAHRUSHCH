extends CharacterBody2D
class_name Warrior

const SPEED = 75

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
var moment_to_attack = false
var attack_power = 30
var on_the_ground_right:bool
var on_the_ground_left:bool

func _ready():
	if randf() < 0.5:
		direction = -1
	else:
		direction = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation = $AnimatedSprite2D
@onready var attack_zone = $Zones/AttackZone
@onready var damage_deal_zone = $Zones/DamageDealZone

func _physics_process(delta):
	match current_state:
		states.Idle:
			velocity.x = 0;
			if not is_on_floor():
				current_state = states.Walk
			animation.play("idle")
			if target != null:
				current_state = states.Walk
		states.Walk:
			animation.play("run")
			if not is_on_floor():
				velocity.y += gravity * delta
			$Label2.set_text(str(on_the_ground_left))
			$Label3.set_text(str(on_the_ground_right))
			if target != null && target.position.x < position.x:
				direction = -1
			elif target != null: 
				direction = 1
			
			if !on_the_ground_left:
				direction = -1
			elif !on_the_ground_right:
				direction = 1
			elif target == null && animation.is_flipped_h():
				direction = -1
			elif target == null && !animation.is_flipped_h():
				direction = 1
				
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)

			if direction > 0:
				animation.set_flip_h(false)
				attack_zone.set_scale(Vector2(1,1))
				damage_deal_zone.set_scale(Vector2(1,1))
			elif direction < 0:
				animation.set_flip_h(true)
				attack_zone.set_scale(Vector2(-1,1))
				damage_deal_zone.set_scale(Vector2(-1,1))
				
		states.Attack:
			if _body != null:
				velocity.x = 0;
				animation.play("attack")
				if animation.get_frame() == 9:
					damage_deal_zone.set_monitoring(true)
				elif animation.get_frame() == 11:
					damage_deal_zone.set_monitoring(false)
				
		states.GetHit:
			animation.play("take_hit")
			print(Hp)
			if Hp <= 0:
				current_state = states.Death
			
		states.Death:
			print("Warrior is dead")
			attack_zone.set_monitoring(false)
			damage_deal_zone.set_monitoring(false)
			$Zones/TakeHitZone.set_monitorable(false)
			$Zones/WatchZone.set_monitoring(false)
			animation.play("death")
			
	$Label.set_text(states.keys()[current_state])			
	move_and_slide()


func _on_watch_zone_body_entered(body):
	current_state = states.Walk
	_body = body
	target = body

func _on_watch_zone_body_exited(body):
	if current_state != states.Death && current_state != states.Attack:
		current_state = states.Idle
	target = null

func _on_attack_zone_body_entered(body):
	body_exited = false
	current_state = states.Attack
	
func _on_attack_zone_body_exited(body):
	body_exited = true


func _on_animated_sprite_2d_animation_finished():
	if body_exited && current_state == states.Attack:
		current_state = states.Idle
	if current_state == states.GetHit:
		if Hp <= 0:
			current_state = states.Death
		else:
			current_state = states.Attack
	if current_state == states.Death:
		queue_free()


func _on_damage_deal_zone_body_entered(body):
	if body.has_method("hitted"):
		body.hitted(attack_power, position.x)

func take_hit(value:):
	print("Warrior take hit by %s" % value)
	Hp -= value;
	current_state = states.GetHit


func _on_time_until_run_timeout():
	if target == null:
		current_state = states.Walk


func _on_not_fall_zone_right_body_entered(body):
	on_the_ground_right = true
	print("right collide")

func _on_not_fall_zone_right_body_exited(body):
	on_the_ground_right = false
	print("right out")

func _on_not_fall_zone_left_body_entered(body):
	on_the_ground_left = true
	print("left collide")

func _on_not_fall_zone_left_body_exited(body):
	on_the_ground_left = false
	print("left out")
