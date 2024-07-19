extends StateWizard


# Called when the node enters the scene tree for the first time.
func enter(_msg: Dictionary = {}):
	$"../../Label".set_text(name)
	if wizard.Hp <= 0:
		state_machine.change_to("Death")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func inner_physics_process(_delta):
	wizard.animation.play("take_hit")


func _on_watch_zone_body_entered(body):
	wizard.body_exited = false
	wizard.target_player = body


func _on_watch_zone_body_exited(body):
	wizard.body_exited = true


func _on_animated_sprite_2d_animation_finished():
	if wizard.Hp > 0:
		state_machine.change_to("Idle")
		wizard.hitted_by_player = false
