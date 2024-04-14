extends Control

@export var button_group:ButtonGroup

func _on_choose_world_pressed():
	$Main.hide()
	$Worlds.show()


func _on_options_pressed():
	#get_tree().change_scene_to_file("res://scenes/gui/menus/test_menu_scene.tscn")
	pass


func _on_exit_pressed():
	get_tree().quit()


func _on_close_pressed():
	$Worlds.hide()
	$Main.show()


func _on_play_pressed():
	var pressed_button = button_group.get_pressed_button()
	if pressed_button != null:
		get_tree().change_scene_to_file("res://scenes/gui/menus/test_menu_scene.tscn")

