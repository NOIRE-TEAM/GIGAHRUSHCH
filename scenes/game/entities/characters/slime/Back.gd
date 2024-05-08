extends HitBox

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hit(value: int = 0):
	if value > 10:
		value -= 10
	enemy.take_hit(value)
	$"../../Label".set_text("It hurt man, my ass")
	if enemy.animation.is_flipped_h():
		enemy.animation.set_flip_h(false)
		enemy.hitboxes.set_scale(Vector2(1, 1))
	else:
		enemy.animation.set_flip_h(true)
		enemy.hitboxes.set_scale(Vector2(-1, 1))
