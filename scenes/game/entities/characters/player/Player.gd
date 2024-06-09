#player.gd
class_name Player
extends CharacterBody2D
const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const RUN_INERTION = 30.0
const ATTACK_INERTION = 10
const ATTACK_2_POWER = 30
const time_for_time = 0.35

signal u_turn

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var hp = 1000
var giga_class: String
var get_hitted = false
var enemy_coordinates = 0

var audio:AudioStream 

@onready var tilemap = $"../TileMap"
@onready var timer = $Timer
@onready var run_sound = $RunSound

func change_parametrs_hp(health: int):
	hp = health;
	$Control/L_hp.set_text(str(hp))

func transform_to_string() -> String:
	var stroke:String
	stroke += "hp" + str(hp) + "$" + "giga_class" + "$" + giga_class
	queue_free()
	return stroke

func hitted(value:int, coordinates:float):
	if !get_hitted:
		print("Player is hitted")
		hp -= value
		get_hitted = true
		enemy_coordinates = coordinates

@onready var animation = $AnimatedSprite2D
#@onready var zones = $Zones
@onready var attack_2_zone = $"Zones/Attack#2"
#func _physics_process(delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
	#animation.play()
	


func _on_timer_timeout():
	tilemap.tile_set.set_physics_layer_collision_layer(1,1)
