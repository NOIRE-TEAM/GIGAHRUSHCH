extends Node2D

var limLeftMem
var limBotMem
var limTopMem
var limRightMem

func _ready():
	var limLeftMem = $Player/CameraPivot/Camera2D.limit_left
	var limBotMem = $Player/CameraPivot/Camera2D.limit_bottom
	var limTopMem = $Player/CameraPivot/Camera2D.limit_top
	var limRightMem = $Player/CameraPivot/Camera2D.limit_right
	
	$Player/CameraPivot/Camera2D.limit_left = 1075
	$Player/CameraPivot/Camera2D.limit_bottom = 16
	$Player/CameraPivot/Camera2D.limit_top = -300
	$Player/CameraPivot/Camera2D.limit_right = 1500

	$AnimationPlayer.play("prolog")
	$Player.set_physics_process(false)
	#$Test_Animation/Label.position = $Player/CameraPivot/Camera2D.get_screen_center_position()


func _on_area_2d_body_entered(body):
	get_tree().change_scene_to_file("res://scenes/game/levels/open_world.tscn")

func change_camera_left_location(value:int):
	$Player/CameraPivot/Camera2D.limit_left = value
