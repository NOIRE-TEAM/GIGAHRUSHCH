extends Area2D
class_name HitBox

@onready var enemy = owner as Enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hit(value: int = 0):
	enemy.take_hit(value)
	$"../../Label".set_text("It hurt man, my %s..." % name)
