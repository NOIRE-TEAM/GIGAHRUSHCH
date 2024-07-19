extends StateWizard


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func inner_physics_process(_delta):
	if wizard.body_exited:
		state_machine.change_to("Attack")
	elif wizard.walk_timer.time_left == 0:
		wizard.walk_timer.start(wizard.WALK_TIME)
		state_machine.change_to("Walk")
	elif wizard.hitted_by_player:
		state_machine.change_to("Hitted")
	else:
		wizard.animation.play("idle")



func _on_watch_zone_body_entered(body):
	wizard.body_exited = false
	wizard.target_player = body


func _on_watch_zone_body_exited(body):
	wizard.body_exited = true
