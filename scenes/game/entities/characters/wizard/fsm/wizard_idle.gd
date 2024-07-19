extends StateWizard


# Called when the node enters the scene tree for the first time.
func enter(_msg: Dictionary = {}):
	wizard.velocity.x = 0
	$"../../Label".set_text(name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func inner_physics_process(_delta):
	if not wizard.is_on_floor():
		wizard.velocity.y += wizard.gravity * _delta
	wizard.move_and_slide()
	
	if !wizard.body_exited:
		wizard.walk_timer.stop()
		state_machine.change_to("Attack")
	elif wizard.walk_timer.time_left == 0:
		wizard.walk_timer.start(wizard.WALK_TIME)
		state_machine.change_to("Walk")
	elif wizard.hitted_by_player:
		wizard.walk_timer.stop()
		state_machine.change_to("Hitted")
	wizard.animation.play("idle")


func _on_watch_zone_body_entered(body):
	wizard.body_exited = false
	wizard.target_player = body


func _on_watch_zone_body_exited(body):
	wizard.body_exited = true


func _on_walk_timer_timeout():
	pass
