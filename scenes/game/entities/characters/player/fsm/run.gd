extends StatePlayer

func enter(_msg: Dictionary = {}):
	$"../../Control/L_hp".set_text(str(player.hp))
	player.audio = preload("res://assets/audio/sounds/game/main_person_running.mp3")
	player.run_sound.set_stream(player.audio)
	player.animation.set_speed_scale(2)
	$"../../Control/L_state".set_text(name)
	pass
	
func inner_physics_process(delta):
	$"../../Control/L_velocity_x".set_text(str(player.velocity.x))
	$"../../Control/L_velocity_y".set_text(str(player.velocity.y))
	
	if player.run_sound.playing == false:
		player.run_sound.play()
	if player.get_hitted:
		state_machine.change_to("Hitted")
	if Input.is_action_just_pressed("ui_down") and !player.get_hitted:
		player.tilemap.tile_set.set_physics_layer_collision_layer(1,16)
		player.timer.wait_time = player.time_for_time
		player.timer.start(player.time_for_time)
	if not player.is_on_floor():
		player.run_sound.stop()
		state_machine.change_to("Air")
		
	if Input.is_action_just_pressed("ui_attack_2") and !player.get_hitted:
		player.run_sound.stop()
		state_machine.change_to("Attack#2")
	#
	if Input.is_action_just_pressed("ui_jump") and !player.get_hitted:
		player.run_sound.stop()
		state_machine.change_to("Air", {do_jump = true})
	
	var direction = Input.get_axis("ui_left", "ui_right")
	$"../../Control/L_direction".set_text(str(direction));
	if direction and !player.get_hitted:
		player.velocity.x = direction * player.SPEED
	elif !player.get_hitted:
		player.velocity.x = move_toward(player.velocity.x, 0, player.RUN_INERTION)
	
	if direction < 0 and not player.animation.is_flipped_h():
		player.animation.set_flip_h(true)
		player.u_turn.emit("left")
	elif direction > 0 and player.animation.is_flipped_h():
		player.animation.set_flip_h(false)
		player.u_turn.emit("right")
		
	if !Input.is_action_just_pressed("ui_jump") and !player.get_hitted:
		player.move_and_slide()
		
	if player.velocity.x == 0 and direction == 0 and !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right") and !player.get_hitted:
		player.run_sound.stop()
		state_machine.change_to("Idle")
	elif Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right") and !player.get_hitted:
		player.run_sound.stop()
		state_machine.change_to("Idle")
	player.animation.play("run")
