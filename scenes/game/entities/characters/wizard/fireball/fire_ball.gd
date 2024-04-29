extends Node2D

var speed = 100
var target:Node2D
var is_explode = false
var already_hit:bool
var attack_power = 35

@onready var animation = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	already_hit = false
	animation.play("move")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	if !is_explode && target:
		look_at(target.get_position())
		position += transform.x * speed  * delta

func set_target(_body):
	target = _body

func explode():
	is_explode = true
	animation.play("explode")
	

func _on_timer_timeout():
	explode()


func _on_animated_sprite_2d_animation_finished():
	queue_free()


func _on_hitboxe_body_entered(body):
	if not already_hit:
		if body.has_method("hitted"):
			body.hitted(attack_power)
		already_hit = true
	explode()
