extends Control

func resume() :
	$Settings.hide()
	get_tree().paused = false

func pause():
	get_tree().paused = true
	$Settings.show()

func testEsc():
	if Input.is_action_just_pressed("escape") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("escape") and get_tree().paused:
		resume()

func _on_close_settings_mouse_entered():
	$HoverButton.play()

func _on_close_settings_pressed():
	resume()
	
func _process(_delta):
	testEsc()
	
func _ready():
	$Settings.hide()


func _on_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/gui/menus/mainMenu/main_menu.tscn")
