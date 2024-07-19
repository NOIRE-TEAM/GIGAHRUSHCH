extends StateWarrior


# Called when the node enters the scene tree for the first time.
func enter(_msg: Dictionary = {}):
	$"../../Label".set_text(name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func inner_physics_process(delta):
	if not warrior.is_on_floor():
		warrior.velocity.y += warrior.gravity * delta
	if warrior.direction:
		warrior.velocity.x = warrior.direction * warrior.SPEED
	else:
		warrior.velocity.x = warrior.move_toward(warrior.velocity.x, 0, warrior.SPEED)

	if warrior.target_player != null && warrior.target_player.position.x < warrior.position.x:
		warrior.direction = -1
	elif warrior.target_player != null: 
		warrior.direction = 1

	if warrior.direction > 0:
		warrior.animation.set_flip_h(false)
		warrior.attack_zone.set_scale(Vector2(1,1))
		warrior.damage_deal_zone.set_scale(Vector2(1,1))
	elif warrior.direction < 0:
		warrior.animation.set_flip_h(true)
		warrior.attack_zone.set_scale(Vector2(-1,1))
		warrior.damage_deal_zone.set_scale(Vector2(-1,1))
	
	if !warrior.body_exited:
		warrior.walk_timer.stop()
		state_machine.change_to("Attack")
	elif warrior.target_player == null && warrior.walk_timer.time_left == 0:
		warrior.walk_timer.start(warrior.WALK_TIME)
		state_machine.change_to("Idle")
	elif warrior.walk_timer.wait_time == 0:
		warrior.walk_timer.start(warrior.WALK_TIME)
		state_machine.change_to("Idle")
	elif warrior.hitted_by_player:
		warrior.walk_timer.stop()
		state_machine.change_to("Hitted")
	else:
		warrior.animation.play("run")
	warrior.move_and_slide()

func _on_watch_zone_body_entered(body):
	warrior.target_player = body

func _on_watch_zone_body_exited(body):
	warrior.target_player = null
	
func _on_time_until_run_timeout():
	if warrior.direction >= 0:
		warrior.direction = -1
	else:
		warrior.direction = 1

func _on_attack_zone_body_entered(body):
	warrior.body_exited = false

func _on_attack_zone_body_exited(body):
	warrior.body_exited = true
