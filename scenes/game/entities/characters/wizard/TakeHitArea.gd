extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

@onready var wizard = owner as Wizard

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hit(value: int = 0):
	wizard.take_hit(value)
	if wizard.animation.is_flipped_h():
		wizard.animation.set_flip_h(false)
		wizard.attack_zone.set_scale(Vector2(1, 1))
	else:
		wizard.animation.set_flip_h(true)
		wizard.attack_zone.set_scale(Vector2(-1, 1))
