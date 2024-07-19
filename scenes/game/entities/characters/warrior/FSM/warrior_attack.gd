extends StateWarrior


# Called when the node enters the scene tree for the first time.
func enter(_msg: Dictionary = {}):
	$"../../Label".set_text(name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func inner_physics_process(_delta):
	print("moment_to_attack: " + str(warrior.moment_to_attack))
	print("target_player: " + str(warrior.target_player))
	print("body_exited: " + str(warrior.body_exited))
	if warrior.target_player != null && !warrior.body_exited:
		warrior.moment_to_attack = true
		warrior.velocity.x = 0;
		if not warrior.attack_first_time:
			warrior.anim_attack_num = str(randi() % 3 + 1)
			warrior.attack_first_time = true
			warrior.animation_attack = "attack#" + warrior.anim_attack_num
		warrior.animation.play(warrior.animation_attack)
		if warrior.anim_attack_num == "1":
			#print(animation_attack + str(animation.get_frame()))
			if warrior.animation.get_frame() == 4:
				warrior.damage_deal_zone.set_monitoring(true)
			elif warrior.animation.get_frame() == 5:
				warrior.damage_deal_zone.set_monitoring(false)
		elif warrior.anim_attack_num == "2":
			if warrior.animation.get_frame() == 2:
				warrior.damage_deal_zone.set_monitoring(true)
			elif warrior.animation.get_frame() == 3:
				warrior.damage_deal_zone.set_monitoring(false)
		elif warrior.anim_attack_num == "3":
			if warrior.animation.get_frame() == 3:
				warrior.damage_deal_zone.set_monitoring(true)
			elif warrior.animation.get_frame() == 4:
				warrior.damage_deal_zone.set_monitoring(false)
				
	if warrior.body_exited && !warrior.moment_to_attack:
		warrior.walk_timer.start(warrior.WALK_TIME)
		state_machine.change_to("Walk")
	elif warrior.hitted_by_player:
		state_machine.change_to("Hitted")

func _on_animated_sprite_2d_animation_finished():
	warrior.moment_to_attack = false
	if warrior.body_exited:
		warrior.damage_deal_zone.set_monitoring(false)

func _on_damage_deal_zone_body_entered(body):
	if body.has_method("hitted"):
		body.hitted(warrior.ATTACK_POWER, warrior.position.x)
