extends StateWarrior


# Called when the node enters the scene tree for the first time.
func enter(_msg: Dictionary = {}):
	warrior.velocity.x = 0
	$"../../Label".set_text(name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func inner_physics_process(_delta):
	if not warrior.is_on_floor():
		warrior.velocity.y += warrior.gravity * _delta
	warrior.move_and_slide()
	
	if !warrior.body_exited:
		warrior.walk_timer.stop()
		state_machine.change_to("Attack")
	elif warrior.target_player != null:
		#warrior.walk_timer.stop()
		state_machine.change_to("Walk")
	elif warrior.walk_timer.time_left == 0:
		warrior.walk_timer.start(warrior.WALK_TIME)
		state_machine.change_to("Walk")
	elif warrior.hitted_by_player:
		warrior.walk_timer.stop()
		state_machine.change_to("Hitted")
	warrior.animation.play("idle")


func _on_watch_zone_body_entered(body):
	warrior.target_player = body

func _on_watch_zone_body_exited(body):
	warrior.target_player = null

func _on_time_until_run_timeout():
	pass # Replace with function body.

func _on_attack_zone_body_entered(body):
	warrior.body_exited = false

func _on_attack_zone_body_exited(body):
	warrior.body_exited = true
