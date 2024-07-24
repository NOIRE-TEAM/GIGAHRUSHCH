extends StateWizard


# Called when the node enters the scene tree for the first time.
func enter(_msg: Dictionary = {}):
	$"../../Label".set_text(name)
	GlobalVariables.monsters.erase(wizard)
	wizard.attack_zone.set_monitoring(false)
	wizard.take_hit_area.set_monitorable(false)
	if wizard.alive:
		wizard.animation.play("death")
	

 #Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animated_sprite_2d_animation_finished():
	if wizard.Hp <= 0:
		wizard.alive = false
		wizard.get_parent().get_node("Player").gain_exp(10)
		#wizard.player_object.gain_exp(10)
		wizard.queue_free()
