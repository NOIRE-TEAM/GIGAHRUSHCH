extends StateWizard


# Called when the node enters the scene tree for the first time.
func enter(_msg: Dictionary = {}):
	$"../../Label".set_text(name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func inner_physics_process(delta):
	if not wizard.is_on_floor():
		wizard.velocity.y += wizard.gravity * delta
	if wizard.direction:
		wizard.velocity.x = wizard.direction * wizard.SPEED
	else:
		wizard.velocity.x = wizard.move_toward(wizard.velocity.x, 0, wizard.SPEED)

	if wizard.direction > 0:
		wizard.animation.set_flip_h(false)
		wizard.muzzle.position.x = abs(wizard.muzzle.position.x)
		wizard.attack_zone.set_scale(Vector2(1,1))
	elif wizard.direction < 0:
		wizard.animation.set_flip_h(true)
		wizard.muzzle.position.x = -wizard.muzzle.position.x
		wizard.attack_zone.set_scale(Vector2(-1,1))
	
	if !wizard.body_exited:
		wizard.walk_timer.stop()
		state_machine.change_to("Attack")
	elif wizard.walk_timer.time_left == 0:
		wizard.walk_timer.start(wizard.WALK_TIME)
		state_machine.change_to("Idle")
	elif wizard.hitted_by_player:
		wizard.walk_timer.stop()
		state_machine.change_to("Hitted")
	else:
		wizard.animation.play("walk")
	wizard.move_and_slide()


func _on_watch_zone_body_entered(body):
	wizard.body_exited = false
	wizard.target_player = body


func _on_watch_zone_body_exited(body):
	wizard.body_exited = true


func _on_walk_timer_timeout():
	if wizard.direction >= 0:
		wizard.direction = -1
	else:
		wizard.direction = 1
