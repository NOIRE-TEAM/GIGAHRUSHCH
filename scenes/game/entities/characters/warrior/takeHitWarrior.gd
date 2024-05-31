extends Area2D

@onready var warrior = owner as Warrior
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func hit(value: int, player_pos: int):
	if player_pos < warrior.position.x:
		warrior.animation.set_flip_h(true)
		warrior.attack_zone.set_scale(Vector2(-1, 1))
		warrior.damage_deal_zone.set_scale(Vector2(-1, 1))
	else:
		warrior.animation.set_flip_h(false)
		warrior.attack_zone.set_scale(Vector2(1, 1))
		warrior.damage_deal_zone.set_scale(Vector2(1, 1))
	warrior.take_hit(value)

