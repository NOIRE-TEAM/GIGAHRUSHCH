extends Control

@export var button_group:ButtonGroup

func _ready():
	$Worlds.hide()
	$Settings.hide()
	$Main.show()

func _on_choose_world_pressed():
	var worlds_container = $Worlds/WorldsChoose/ScrollContainer/VBoxContainer
	for child in worlds_container.get_children():
		child.queue_free()
	var dir = DirAccess.open("res://saves")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				var butt = Button.new()
				butt.text = file_name
				butt.button_group = button_group
				butt.toggle_mode = true
				print(butt)
				#butt.font_size = 20
				#print(button_group.get_buttons())
				worlds_container.add_child(butt)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the saves.")
	
	$Main.hide()
	$Worlds.show()
	$Worlds/NewWorld.hide()
	$Worlds/WorldsChoose.show()


func _on_options_pressed():
	$Main.hide()
	$Settings.show()


func _on_exit_pressed():
	get_tree().quit()


func _on_close_pressed():
	$Worlds.hide()
	$Main.show()


func _on_play_pressed():
	#print(button_group.get_pressed_button())
	#print(button_group.get_buttons())
	var pressed_button = button_group.get_pressed_button()
	if pressed_button != null:		
		GlobalVariables.CurrentWorld = pressed_button.text
		get_tree().change_scene_to_file("res://scenes/gui/menus/test_menu_scene.tscn")



func _on_close_settings_pressed():
	$Settings.hide()
	$Main.show()


func _on_close_settings_mouse_entered():
	$HoverButton.play()


func _on_new_world_pressed():
	$Worlds/WorldsChoose.hide()
	$Worlds/NewWorld.show()


func _on_create_pressed():
	GlobalVariables.CurrentWorld = $Worlds/NewWorld/TextEdit.text
	get_tree().change_scene_to_file("res://scenes/gui/menus/test_menu_scene.tscn")


func _on_cancel_pressed():
	$Worlds/WorldsChoose.show()
	$Worlds/NewWorld.hide()
