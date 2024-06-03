extends StatePlayer

var already_hit: bool

# Called when the node enters the scene tree for the first time.
func enter(_msg: Dictionary={}):
	already_hit = false
	$"../../Control/L_state".set_text(name)
	if player.animation.is_flipped_h():
		player.attack_2_zone.set_scale(Vector2(-1,1))
	else:
		player.attack_2_zone.set_scale(Vector2(1,1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func inner_physics_process(_delta):
	if player.get_hitted:
		state_machine.change_to("Hitted")
	
	if not player.is_on_floor():
		state_machine.change_to("Air")
	
	player.animation.play("attack")


	if player.animation.get_frame() == 2:
		player.attack_2_zone.set_monitoring(true)
	elif player.animation.get_frame() == 8:
		player.attack_2_zone.set_monitoring(false)

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

func _on_attack_2_area_entered(area):
	if not already_hit:
		print(area.owner.name)
		if area.has_method("hit"):
			area.hit(50, player.position.x)
		already_hit = true
	
