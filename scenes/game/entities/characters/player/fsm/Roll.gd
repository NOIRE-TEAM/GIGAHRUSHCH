extends StatePlayer

func enter(_msg: Dictionary = {}):
	player.animation.set_speed_scale(2)

func inner_physics_process(delta):
	player.animation.play("roll")

func _on_animated_sprite_2d_animation_finished():
	state_machine.change_to("Idle")
