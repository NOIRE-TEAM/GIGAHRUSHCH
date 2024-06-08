extends WorldSaver

var placing: TileMap
var player: CharacterBody2D
var monsters = []
var warriorNode: PackedScene
var wizardNode: PackedScene

const door = [[38, 39, 40],
			  [41, 42, 43],
			  [44, 45, 46],
			  [47, 48, 49]]

const stairs = [[ 3, 13, 16, 29,  3,  3,  3,  4,  5,  2,  2, 21],
				[ 3,  3,  3, 13, 16, 29,  5,  2,  2,  2,  2, 21],
				[ 3,  3,  3,  4,  5, 34, 35, 30, 12, 12, 12, 21],
				[ 3,  4,  5,  2,  2,  8,  9, 33,  7, 11, 11, 23],
				[ 2,  2,  2,  8,  9,  6,  7, 10,  3,  3,  3, 21],
				[ 2,  8,  9,  6,  7, 10,  3,  3,  3,  3,  3, 21],
				[ 9,  6,  7, 10,  3,  3,  3,  3,  3,  3,  3, 21],
				[16, 37,  3,  3,  3,  3,  3,  3,  3,  3,  3, 21]]

func gen_chunk(start_x: int, start_y: int):
	for add_y in range(self.CHUNK_SIZE_Y):
		for add_x in range(self.CHUNK_SIZE_X):
			var add_y_8 = add_y % 8
			var where = Vector2(start_x + add_x, start_y + add_y)
			if (start_x == -1 && add_x >= self.CHUNK_SIZE_X - 12): # stairs
				placing.set_cell(0, where, 0, Vector2i(stairs[add_y_8][(add_x + 12 - self.CHUNK_SIZE_X)], 0))
			elif (3 <= add_y_8 && add_y_8 <= 6 && add_x < 3): # door
				placing.set_cell(0, where, 0, Vector2i(door[add_y_8 - 3][add_x], 0))
			elif (add_y_8 < 4):
				placing.set_cell(0, where, 0, Vector2i(3, 0))
			elif (add_y_8 == 6):
				placing.set_cell(0, where, 0, Vector2i(12, 0))
				if (add_x == self.CHUNK_SIZE_X / 3):
					SpawnWizard(where * placing.tile_set.tile_size.x)
				elif (add_x == self.CHUNK_SIZE_X - self.CHUNK_SIZE_X / 3):
					SpawnWarrior(where * placing.tile_set.tile_size.x)
			elif (add_y_8 == 7):
				placing.set_cell(0, where, 0, Vector2i(11, 0))
			else:
				placing.set_cell(0, where, 0, Vector2i(2, 0))

func to_tilemap(x: int, y: int, content: PackedByteArray):
	var start_x: int = (x << self.CHUNK_SIZE_X_POW) - 1
	var start_y: int = (y << self.CHUNK_SIZE_Y_POW) - 1
	for add_y in range(self.CHUNK_SIZE_Y):
		for add_x in range(self.CHUNK_SIZE_X):
			var iter: int = (add_y << self.CHUNK_SIZE_Y_POW) + add_x
			if content[iter] == 0:
				gen_chunk(start_x, start_y)
				return
			else:
				placing.set_cell(0, Vector2(start_x + add_x, start_y + add_y), 0, Vector2i(content[iter], 0))

func from_tilemap(x: int, y: int):
	var start_x: int = (x << self.CHUNK_SIZE_X_POW) - 1
	var start_y: int = (y << self.CHUNK_SIZE_Y_POW) - 1
	var ret: PackedByteArray = []
	for add_y in range(self.CHUNK_SIZE_Y):
		for add_x in range(self.CHUNK_SIZE_X):
			var tile = Vector2(start_x + add_x, start_y + add_y)
			#var tmp = placing.get_cell_atlas_coords(0, tile).x
			#if tmp <= 0:
			#	print(tmp, "from at", start_x, " ", start_y, " ", x, " ", y)
			ret.append(placing.get_cell_atlas_coords(0, tile).x)
			placing.erase_cell(0, tile)
	return ret

func SpawnWizard(pos: Vector2):
	var mage = wizardNode.instantiate()
	mage.set_position(pos)
	add_child(mage)
	add_monster(mage)
	
func SpawnWarrior(pos: Vector2):
	var warrior = warriorNode.instantiate()
	warrior.set_position(pos)
	add_child(warrior)
	add_monster(warrior)

func DeleteAllMonsters():
	for monster in monsters:
		if (player.get_position() - monster.get_position()).length() > self.CHUNK_SIZE_X * placing.tile_set.tile_size.x:
			monsters.erase(monster)
			monster.queue_free()

func add_monster(monster: CharacterBody2D):
	monsters.append(monster)

func _ready():
	$"../AudioStreamPlayer".play()
	warriorNode = preload("res://scenes/game/entities/characters/warrior/warrior.tscn")
	wizardNode = preload("res://scenes/game/entities/characters/wizard/wizard.tscn")
	player = get_child(0)
	placing = get_child(1)
	self.start(GlobalVariables.CurrentWorld, placing.tile_set.tile_size.x, placing.tile_set.tile_size.y)

func _physics_process(_delta):
	DeleteAllMonsters()
	self.set_view_center(player.position.x, player.position.y)
	unload_all()
	load_all()
	var tile: Vector2 = placing.local_to_map(placing.get_global_mouse_position())
	var to_replace = placing.get_cell_atlas_coords(0, tile).x
	if (Input.is_action_just_pressed("ui_attack")):
		if to_replace >= 51 || to_replace == 19 || to_replace == 18 || to_replace <= 5:
			placing.set_cell(0, tile, 0, Vector2i(50, 0))
	if (Input.is_action_just_pressed("ui_attack_2")):
		if 6 <= to_replace && to_replace <= 17:
			placing.set_cell(0, tile, 0, Vector2i(45 + to_replace, 0))
		elif 20 <= to_replace && to_replace <= 37:
			placing.set_cell(0, tile, 0, Vector2i(43 + to_replace, 0))
		elif to_replace == 50:
			placing.set_cell(0, tile, 0, Vector2i(81, 0))

func load_all():
	var payload: PackedByteArray = self.load_another_one()
	while !payload.is_empty():
		var fields = payload.slice(0, 16).to_int64_array()
		to_tilemap(fields[0], fields[1], payload.slice(16))
		payload = self.load_another_one()

func unload_all():
	var unload_xy: PackedInt64Array = self.which_to_unload()
	while !unload_xy.is_empty():
		var payload_unl_xy = unload_xy.to_byte_array()
		payload_unl_xy.append_array(from_tilemap(unload_xy[0], unload_xy[1]))
		self.unload(payload_unl_xy)
		unload_xy = self.which_to_unload()

func _notification(what):
	match what:
		NOTIFICATION_PREDELETE:
			self.exit()
			unload_all()
