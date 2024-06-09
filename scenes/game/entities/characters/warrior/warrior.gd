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
var anim_attack_num
var attack_first_time:bool = false
var animation_attack

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
@onready var being_hitted_timer = $TimerWhileHitted

func _physics_process(delta):
	match current_state:
		states.Idle:
			velocity.x = 0;
			animation.play("idle")
			if being_hitted_timer.time_left == 0:
				if not is_on_floor():
					current_state = states.Walk
				if target != null:
					current_state = states.Walk
		states.Walk:
			if being_hitted_timer.time_left == 0:
				animation.play("run")
				if not is_on_floor():
					velocity.y += gravity * delta
				if target != null && target.position.x < position.x:
					direction = -1
				elif target != null: 
					direction = 1
			
				if target == null && animation.is_flipped_h():
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
			if being_hitted_timer.time_left == 0:
				if _body != null:
					velocity.x = 0;
					if not attack_first_time:
						anim_attack_num = str(randi() % 3 + 1)
						attack_first_time = true
						animation_attack = "attack#" + anim_attack_num
					animation.play(animation_attack)
					if anim_attack_num == "1":
						#print(animation_attack + str(animation.get_frame()))
						if animation.get_frame() == 4:
							damage_deal_zone.set_monitoring(true)
						elif animation.get_frame() == 5:
							damage_deal_zone.set_monitoring(false)
					elif anim_attack_num == "2":
						if animation.get_frame() == 2:
							damage_deal_zone.set_monitoring(true)
						elif animation.get_frame() == 3:
							damage_deal_zone.set_monitoring(false)
					elif anim_attack_num == "3":
						if animation.get_frame() == 3:
							damage_deal_zone.set_monitoring(true)
						elif animation.get_frame() == 4:
							damage_deal_zone.set_monitoring(false)
				
		states.GetHit:
			animation.play("take_hit")
			print(Hp)
			if Hp <= 0:
				current_state = states.Death
			
		states.Death:
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
		attack_first_time = false
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
	being_hitted_timer.wait_time = 1
	being_hitted_timer.start()
	
	print("Warrior take hit by %s" % value)
	Hp -= value;
	current_state = states.GetHit


func _on_time_until_run_timeout():
	if target == null:
		current_state = states.Walk
