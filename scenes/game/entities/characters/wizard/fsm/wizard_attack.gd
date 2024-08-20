extends StateWizard


# Called when the node enters the scene tree for the first time.
func enter(_msg: Dictionary = {}):
	#if wizard.animation.is_flipped_h():
		#wizard.muzzle.position.x = -wizard.muzzle.position.x
	#else:
		#wizard.muzzle.position.x = abs(wizard.muzzle.position.x)
	$"../../Label".set_text(name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func inner_physics_process(_delta):
	if wizard.target_player != null:
		wizard.velocity.x = 0;
		wizard.animation.play("attack")
		if wizard.animation.get_frame() == 1 and !wizard.one_fireball_instance_bool:
			wizard.one_fireball_instance_bool = true
			attack_char(wizard.target_player)
	
	if wizard.body_exited && wizard.animation_finished:
		wizard.walk_timer.start(wizard.WALK_TIME)
		state_machine.change_to("Idle")
		wizard.animation_finished = false
	elif wizard.hitted_by_player:
		wizard.walk_timer.stop()
		state_machine.change_to("Hitted")

func attack_char(body):
	if body != null:
		#print("I see you %s" % body.name)
		var rotation
		for i in range(1, 7):
			if wizard.animation.is_flipped_h():
				rotation = -40 + 180
			else:
				rotation = -40
			rotation = rotation + i * 10
			var fireball = wizard.FireBall.instantiate()
			fireball.set_global_position(wizard.muzzle.get_global_position())
			fireball.set_rotation(deg_to_rad(rotation))
			fireball.set_target(body)
			#print(str(get_parent().get_parent().get_parent()))
			get_parent().get_parent().get_parent().add_child(fireball)


func _on_watch_zone_body_exited(body):
	wizard.body_exited = true


func _on_animated_sprite_2d_animation_finished():
	if wizard.body_exited:
		wizard.animation_finished = true
	#print("wizard.one_fireball_instance_bool: " + str(wizard.one_fireball_instance_bool))
	wizard.one_fireball_instance_bool = false
