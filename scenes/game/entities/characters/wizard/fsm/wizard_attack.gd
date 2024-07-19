extends StateWizard


# Called when the node enters the scene tree for the first time.
func enter(_msg: Dictionary = {}):
	$"../../Label".set_text(name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func inner_physics_process(_delta):
	if wizard.target_player != null:
		wizard.velocity.x = 0;
		wizard.animation.play("attack")
		if wizard.animation.get_frame() == 8 and !wizard.one_fireball_instance_bool:
			wizard.one_fireball_instance_bool = true
			attack_char(wizard.target_player)
	
	if wizard.body_exited:
		wizard.walk_timer.start(wizard.WALK_TIME)
		state_machine.change_to("Idle")
	elif wizard.hitted_by_player:
		state_machine.change_to("Hitted")

func attack_char(body):
	if body != null:
		print("I see you %s" % body.name)
		var fireball = wizard.FireBall.instantiate()
		fireball.set_position(wizard.muzzle.get_global_position())
		fireball.set_target(body)
		get_parent().add_child(fireball)


func _on_watch_zone_body_exited(body):
	wizard.body_exited = true


func _on_animated_sprite_2d_animation_finished():
	wizard.one_fireball_instance_bool = false
