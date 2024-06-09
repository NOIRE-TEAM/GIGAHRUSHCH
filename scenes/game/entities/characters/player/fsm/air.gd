extends StatePlayer

var is_do_jump:bool = false

func enter(msg: Dictionary = {}):
	$"../../Control/L_hp".set_text(str(player.hp))
	player.audio = preload("res://assets/audio/sounds/game/main_char_jump.mp3")
	player.run_sound.set_stream(player.audio)
	player.animation.set_speed_scale(2)
	if msg.has("do_jump"):
		is_do_jump = true
		player.velocity.y = player.JUMP_VELOCITY
		#print(player.velocity.y)
		player.run_sound.play()
	else:
		player.timer.wait_time = player.time_for_time
		player.timer.start(player.time_for_time)
		is_do_jump = false
	$"../../Control/L_state".set_text(name)
	if player.velocity.y < 0:
		print("Start 16")
		player.tilemap.tile_set.set_physics_layer_collision_layer(1,16)
	elif msg.has("do_jump"):
		print("Start 1")
		player.tilemap.tile_set.set_physics_layer_collision_layer(1,1)
	
func inner_physics_process(delta):
	$"../../Control/L_velocity_x".set_text(str(player.velocity.x))
	$"../../Control/L_velocity_y".set_text(str(player.velocity.y))
	if Input.is_action_pressed("ui_down") and !player.get_hitted:
		player.tilemap.tile_set.set_physics_layer_collision_layer(1,16)
		player.timer.wait_time = player.time_for_time
		player.timer.start(player.time_for_time)
	else:
		if player.velocity.y < 0:
			print("Inner 16")
			player.tilemap.tile_set.set_physics_layer_collision_layer(1,16)
		elif is_do_jump:
			print("Inner 1")
			player.tilemap.tile_set.set_physics_layer_collision_layer(1,1)
		elif player.velocity.y > 0 && player.timer.time_left == 0:
			player.tilemap.tile_set.set_physics_layer_collision_layer(1,1)
	if player.velocity.y <0:
		player.animation.play("jump")
	elif player.velocity.y > 0:
		player.animation.play("fall")

	if player.velocity.y < 500:
		player.velocity.y += player.gravity * delta
	
	if player.get_hitted:
		state_machine.change_to("Hitted", {in_air = true})
	
	var direction = Input.get_axis("ui_left", "ui_right")
	$"../../Control/L_direction".set_text(str(direction));
	if direction and !player.get_hitted:
		player.velocity.x = direction * player.SPEED
	elif !player.get_hitted:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)

	if direction < 0 and not player.animation.is_flipped_h():
		player.animation.set_flip_h(true)
		player.u_turn.emit("left")
	elif direction > 0 and player.animation.is_flipped_h():
		player.animation.set_flip_h(false)
		player.u_turn.emit("right")

	player.move_and_slide()
	
	if player.is_on_floor():
		player.audio = preload("res://assets/audio/sounds/game/main_char_fall.mp3")
		player.run_sound.set_stream(player.audio)
		player.run_sound.play()
		if player.velocity.x == 0 and !player.get_hitted:
			print("Floor 1")
			player.tilemap.tile_set.set_physics_layer_collision_layer(1,1)
			state_machine.change_to("Idle")
		else:
			print("Floor 1")
			player.tilemap.tile_set.set_physics_layer_collision_layer(1,1)
			state_machine.change_to("Run")


func _on_timer_timeout():
	print("Timeout 1")
	player.tilemap.tile_set.set_physics_layer_collision_layer(1,1)
