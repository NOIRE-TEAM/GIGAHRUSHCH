extends StatePlayer

func enter(_msg: Dictionary = {}):
	$"../../Control/L_hp".set_text(str(player.hp))
	player.velocity = Vector2.ZERO
	$"../../Control/L_state".set_text(name)
	
func inner_physics_process(_delta):
	$"../../Control/L_velocity_x".set_text(str(player.velocity.x))
	$"../../Control/L_velocity_y".set_text(str(player.velocity.y))
	
	player.animation.set_speed_scale(2)
	if player.get_hitted:
		state_machine.change_to("Hitted")
	if Input.is_action_just_pressed("ui_down") and !player.get_hitted:
		player.tilemap.tile_set.set_physics_layer_collision_layer(1,16)
		player.timer.wait_time = player.time_for_time
		player.timer.start(player.time_for_time)
	if not player.is_on_floor():
		state_machine.change_to("Air")
		#
		
	#if Input.is_action_just_pressed("ui_attack"):
		#state_machine.change_to("Attack")
		
	if Input.is_action_just_pressed("ui_attack_2") and !player.get_hitted:
		state_machine.change_to("Attack#2")
		#
	player.move_and_slide()
	if Input.is_action_just_pressed("ui_jump") and !player.get_hitted:
		state_machine.change_to("Air", {do_jump = true})
	
	if (Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right")) and !player.get_hitted:
		pass
	elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") and !player.get_hitted:
			state_machine.change_to("Run")
	
	player.animation.play("idle")
