extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func SpawnPlayer(param_stroke: String):
	var spawned_scene = load("res://scenes/game/entities/characters/player/main_char.tscn")
	var player = spawned_scene.instantiate()
	var param:Array = param_stroke.to_lower().split("$", false)
	if param.has("hp"):
		print("Has Hp")
		player.change_parametrs_hp(int(param[param.find("hp") + 1]))
		print(player.hp)
	else:
		print("No hp")
	if param.has("super_name"):
		print("Has name")
		player.giga_class = param[param.find("super_name") + 1]
		print(player.giga_class)
	player.position = Vector2(150,-200)
	
	add_child(player)

func SpawnMage(param_stroke: String):
	var spawned_scene = load("res://scenes/game/entities/characters/wizard/wizard.tscn")
	var mage = spawned_scene.instantiate()
	add_child(mage)
	
func SpawnWarrior(param_stroke: String):
	var spawned_scene = load("res://scenes/game/entities/characters/warrior/warrior.tscn")
	var warrior = spawned_scene.instantiate()
	add_child(warrior)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if (Input.is_action_just_pressed("ui_accept")):
		#SpawnMage("Hp$100$Super_name$plum")
		#SpawnWarrior("Hp$100$Super_name$plum")
	if (Input.is_action_just_pressed("ui_focus_next")):
		if $Player.is_inside_tree():
			var player = get_node("Player")
			print(player.transform_to_string())
