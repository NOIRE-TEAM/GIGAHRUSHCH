extends StatePlayer


# Called when the node enters the scene tree for the first time.
func enter(_msg: Dictionary={}):
	$"../../Control/L_state".set_text(name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func inner_physics_process(_delta):
	if not player.is_on_floor():
		state_machine.change_to("Air")
	
	player.animation.play("attack")

	player.velocity.x = move_toward(player.velocity.x, 0, player.ATTACK_INERTION)
	player.move_and_slide()


func _on_animated_sprite_2d_animation_finished():
	if Input.is_action_pressed("ui_attack"):
		state_machine.change_to("Attack")
	elif Input.is_action_pressed("ui_attack_2"):
		state_machine.change_to("Attack#2")
	elif Input.is_action_pressed("ui_jump"):
		state_machine.change_to("Air", {do_jump=true})
	elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			state_machine.change_to("Run")
	else: 
		state_machine.change_to("Idle")
