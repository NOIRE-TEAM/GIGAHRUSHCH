extends Node2D

var speed = 100
var target:Node2D
var is_explode = false

@onready var animation = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("move")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	if !is_explode:
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
	explode()
