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
	
	$Player/CameraPivot/Camera2D.limit_left = 0
	$Player/CameraPivot/Camera2D.limit_bottom = 16
	$Player/CameraPivot/Camera2D.limit_top = -300
	$Player/CameraPivot/Camera2D.limit_right = 512


func _on_area_2d_body_entered(body):
	print(body)
	get_tree().change_scene_to_file("res://scenes/gui/menus/test_menu_scene.tscn")
