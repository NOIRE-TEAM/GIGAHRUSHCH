extends StateWarrior


# Called when the node enters the scene tree for the first time.
func enter(_msg: Dictionary = {}):
	$"../../Label".set_text(name)
	GlobalVariables.monsters.erase(self)
	warrior.attack_zone.set_monitoring(false)
	warrior.damage_deal_zone.set_monitoring(false)
	$"../../Zones/TakeHitZone".set_monitoring(false)
	$"../../Zones/WatchZone".set_monitoring(false)
	warrior.animation.play("death")

 #Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animated_sprite_2d_animation_finished():
	if warrior.Hp <= 0:
		warrior.get_parent().get_node("Player").gain_exp(10)
		warrior.queue_free()
