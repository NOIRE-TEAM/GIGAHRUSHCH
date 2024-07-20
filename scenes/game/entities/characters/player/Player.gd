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
var stats = {"Сила":1, "Ловкость":1, "Здоровье":1}
var experience = 0
var level = 1
var exp_to_level_up = level * 10
var audio:AudioStream 
var speed_bonus = stats["Ловкость"] * 10
var attack_bonus = stats["Сила"] * 10

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

func gain_exp(value:int):
	experience += value
	if (experience >= exp_to_level_up):
		level += 1
		experience = experience - exp_to_level_up
		exp_to_level_up = level * 10
		$Control/L_str.set_text("Сила: " + str(stats["Сила"]))
		$Control/L_agil.set_text("Ловкость: " + str(stats["Ловкость"]))
		$Control/L_life.set_text("Здоровье: " + str(stats["Здоровье"]))
		$Control/L_str.show()
		$Control/L_agil.show()
		$Control/L_life.show()
	$Control/L_exp.set_text("Опыт: " + str(experience))
	$Control/L_level.set_text("Уровень: " + str(level))

@onready var animation = $AnimatedSprite2D
#@onready var zones = $Zones
@onready var attack_2_zone = $"Zones/Attack#2"

func _ready():
	$Control/L_exp.set_text("Опыт: " + str(experience))
	$Control/L_level.set_text("Уровень: " + str(level))
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


func _on_btn_str_pressed():
	$Control/L_str.hide()
	$Control/L_agil.hide()
	$Control/L_life.hide()
	stats["Сила"] += 1
	attack_bonus = stats["Сила"] * 10


func _on_btn_agil_pressed():
	$Control/L_str.hide()
	$Control/L_agil.hide()
	$Control/L_life.hide()
	stats["Ловкость"] += 1
	speed_bonus = stats["Ловкость"] * 10


func _on_btn_life_pressed():
	$Control/L_str.hide()
	$Control/L_agil.hide()
	$Control/L_life.hide()
	hp = hp + 100
	stats["Здоровье"] += 1
