extends StatePlayer

func enter(_msg: Dictionary = {}):
	$"../../Control/L_state".set_text(name)
	pass
	
func inner_physics_process(delta):
	if not player.is_on_floor():
		state_machine.change_to("Air")
	
	if player.get_hitted:
		state_machine.change_to("Hitted")
	
	if Input.is_action_just_pressed("ui_attack"):
		state_machine.change_to("Attack")
		
	if Input.is_action_just_pressed("ui_attack_2"):
		state_machine.change_to("Attack#2")
	#
	if Input.is_action_just_pressed("ui_jump"):
		state_machine.change_to("Air", {do_jump = true})
	
	var direction = Input.get_axis("ui_left", "ui_right")
	$"../../Control/L_direction".set_text(str(direction));
	if direction:
		player.velocity.x = direction * player.SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.RUN_INERTION)
	
	if direction < 0 and not player.animation.is_flipped_h():
		player.animation.set_flip_h(true)
		player.u_turn.emit("left")
	elif direction > 0 and player.animation.is_flipped_h():
		player.animation.set_flip_h(false)
		player.u_turn.emit("right")
	
	player.move_and_slide()
	
	if player.velocity.x == 0 and direction == 0 and !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right"):
		state_machine.change_to("Idle")
	elif Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right"):
		state_machine.change_to("Idle")
	player.animation.play("run")
