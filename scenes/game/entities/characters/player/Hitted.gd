extends StatePlayer

var in_air = false

# Called when the node enters the scene tree for the first time.
func enter(msg: Dictionary = {}):
	$"../../Control/L_hp".set_text(str(player.hp))
	player.animation.set_speed_scale(2)
	if msg.has("in_air"):
		in_air = true
	if player.enemy_coordinates > player.position.x:
		player.velocity.x = player.velocity.x -300
	else:
		player.velocity.x = player.velocity.x + 300
	$"../../Control/L_state".set_text(name)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func inner_physics_process(delta):
	$"../../Control/L_velocity_x".set_text(str(player.velocity.x))
	$"../../Control/L_velocity_y".set_text(str(player.velocity.y))
	
	if in_air:
		player.velocity.y += player.gravity * delta
	
	if player.hp <= 0:
		player.queue_free()
	player.velocity.x = move_toward(player.velocity.x, 0, player.RUN_INERTION)

	player.move_and_slide()
	
	
	if player.velocity.x == 0:
		player.get_hitted = false
		
		
		if not player.is_on_floor() and !player.get_hitted:
			state_machine.change_to("Air")	
		elif Input.is_action_just_pressed("ui_attack_2") and !player.get_hitted:
			state_machine.change_to("Attack#2")
		elif Input.is_action_just_pressed("ui_jump") and !player.get_hitted:
			state_machine.change_to("Air", {do_jump = true})
		elif (Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right")) and !player.get_hitted:
			pass
		elif (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")) and !player.get_hitted:
				state_machine.change_to("Run")
		else:
			state_machine.change_to("Idle")

