extends StatePlayer

var already_hit: bool
var power_modifer:int = 0

func enter(_msg: Dictionary={}):
	$"../../Control/L_hp".set_text(str(player.hp))
	var audio:AudioStream = preload("res://assets/audio/sounds/game/main_char_attack.mp3")
	player.run_sound.set_stream(audio)
	player.animation.set_speed_scale(4)
	already_hit = false
	$"../../Control/L_state".set_text(name)
	if player.animation.is_flipped_h():
		player.attack_2_zone.set_scale(Vector2(-1,1))
	else:
		player.attack_2_zone.set_scale(Vector2(1,1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func inner_physics_process(_delta):
	$"../../Control/L_velocity_x".set_text(str(player.velocity.x))
	$"../../Control/L_velocity_y".set_text(str(player.velocity.y))
	
	if player.run_sound.playing == false:
		player.run_sound.play()
		
	
	if not player.is_on_floor():
		state_machine.change_to("Air")
	
	player.animation.play("attack#2")

	if player.get_hitted:
		state_machine.change_to("Hitted")

	if player.animation.get_frame() == 5:
		player.attack_2_zone.set_monitoring(true)
	elif player.animation.get_frame() == 7:
		player.attack_2_zone.set_monitoring(false)

	player.velocity.x = move_toward(player.velocity.x, 0, player.ATTACK_INERTION)
	player.move_and_slide()

func _on_animated_sprite_2d_animation_finished():
	if Input.is_action_pressed("ui_attack_2") and !player.get_hitted:
		state_machine.change_to("Attack#2")
	#elif Input.is_action_pressed("ui_attack"):
		#state_machine.change_to("Attack")
	elif Input.is_action_pressed("ui_jump") and !player.get_hitted:
		state_machine.change_to("Air", {do_jump=true})
	elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") and !player.get_hitted:
			state_machine.change_to("Run")
	else: 
		state_machine.change_to("Idle")


func _on_attack_2_area_entered(area):
	power_modifer = abs(int(player.velocity.x))
	if not already_hit:
		print(area.owner.name)
		if area.has_method("hit"):
			area.hit(player.ATTACK_2_POWER + power_modifer, player.position.x)
		already_hit = true
	
