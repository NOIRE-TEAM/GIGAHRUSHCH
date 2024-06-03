extends StatePlayer


# Called when the node enters the scene tree for the first time.
func enter(_msg: Dictionary = {}):
	player.animation.set_speed_scale(2)
	if player.enemy_coordinates > player.position.x:
		player.velocity.x = -200
	else:
		player.velocity.x = 200
	$"../../Control/L_state".set_text(name)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func inner_physics_process(_delta):
	if player.hp <= 0:
		player.queue_free()
	player.get_hitted = false;
	player.velocity.x = move_toward(player.velocity.x, 0, player.RUN_INERTION)
	#TODO: IDLE
	player.move_and_slide()
	if not player.is_on_floor():
		state_machine.change_to("Air")
		
	if player.get_hitted:
		state_machine.change_to("Hitted")
		
	if Input.is_action_just_pressed("ui_attack"):
		state_machine.change_to("Attack")
		
	if Input.is_action_just_pressed("ui_attack_2"):
		state_machine.change_to("Attack#2")
		#
	player.move_and_slide()
	if Input.is_action_just_pressed("ui_jump"):
		state_machine.change_to("Air", {do_jump = true})
	
	if (Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right")):
		pass
	elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") :
			state_machine.change_to("Run")
	
	if player.velocity.x == 0:
		state_machine.change_to("Idle")

