extends StatePlayer


func enter(msg: Dictionary = {}):
	if msg.has("do_jump"):
		player.velocity.y = player.JUMP_VELOCITY
	$"../../Control/L_state".set_text(name)
	
func inner_physics_process(delta):
	
	if player.velocity.y <0:
		player.animation.play("jump")
	elif player.velocity.y > 0:
		player.animation.play("fall")

	if player.velocity.y < 500:
		player.velocity.y += player.gravity * delta
	
	if player.get_hitted:
		state_machine.change_to("Hitted")
	
	var direction = Input.get_axis("ui_left", "ui_right")
	$"../../Control/L_direction".set_text(str(direction));
	if direction:
		player.velocity.x = direction * player.SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)

	if direction < 0 and not player.animation.is_flipped_h():
		player.animation.set_flip_h(true)
		player.u_turn.emit("left")
	elif direction > 0 and player.animation.is_flipped_h():
		player.animation.set_flip_h(false)
		player.u_turn.emit("right")

	player.move_and_slide()
	
	if player.is_on_floor():
		if player.velocity.x == 0:
			state_machine.change_to("Idle")
		else:
			state_machine.change_to("Run")
