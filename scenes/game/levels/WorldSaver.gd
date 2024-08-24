extends WorldSaver

@onready var placing: TileMap = get_child(1)
@onready var player: CharacterBody2D = get_child(0)
@onready var warriorNode: PackedScene = preload("res://scenes/game/entities/characters/warrior/warrior.tscn")
@onready var wizardNode: PackedScene = preload("res://scenes/game/entities/characters/wizard/wizard.tscn")
@onready var tile_size_x: int = placing.tile_set.tile_size.x
@onready var tile_size_y: int = placing.tile_set.tile_size.y
var smth_saved

const door = [
	[38, 39, 40],
	[41, 42, 43],
	[44, 45, 46],
	[47, 48, 49]
]

const stairs = [
	[ 3, 13, 16, 29,  3,  3,  3,  4,  5,  2,  2, 21],
	[ 3,  3,  3, 13, 16, 29,  5,  2,  2,  2,  2, 21],
	[ 3,  3,  3,  4,  5, 34, 35, 30, 12, 12, 12, 21],
	[ 3,  4,  5,  2,  2,  8,  9, 33,  7, 11, 11, 23],
	[ 2,  2,  2,  8,  9,  6,  7, 10,  3,  3,  3, 21],
	[ 2,  8,  9,  6,  7, 10,  3,  3,  3,  3,  3, 21],
	[ 9,  6,  7, 10,  3,  3,  3,  3,  3,  3,  3, 21],
	[16, 37,  3,  3,  3,  3,  3,  3,  3,  3,  3, 21]
]

func gen_chunk(start_x: int, start_y: int):
	for add_y in range(self.CHUNK_SIZE_Y):
		for add_x in range(self.CHUNK_SIZE_X):
			var add_y_8 = add_y % 8
			var where = Vector2i(start_x + add_x, start_y + add_y)
			if (((start_x + 1) >> self.CHUNK_SIZE_X_POW) % 4 == 0 && add_x >= self.CHUNK_SIZE_X - 12): # stairs
				placing.set_cell(0, where, 0, Vector2i(stairs[add_y_8][(add_x + 12 - self.CHUNK_SIZE_X)], 0))
			elif (3 <= add_y_8 && add_y_8 <= 6 && add_x < 3): # door
				placing.set_cell(0, where, 0, Vector2i(door[add_y_8 - 3][add_x], 0))
			elif (add_y_8 < 4):
				placing.set_cell(0, where, 0, Vector2i(3, 0))
			elif (add_y_8 == 6):
				placing.set_cell(0, where, 0, Vector2i(12, 0))
				if (add_x == self.CHUNK_SIZE_X / 3):
					spawn(wizardNode, where * tile_size_x)
				elif (add_x == self.CHUNK_SIZE_X - self.CHUNK_SIZE_X / 3):
					spawn(warriorNode, where * tile_size_x)
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
			if content[iter * 3] == 0:
				gen_chunk(start_x, start_y)
				return
			else:
				placing.set_cell(0, Vector2(start_x + add_x, start_y + add_y), 0, Vector2i(content[iter * 3], 0))
				spawn_monster(start_x + add_x, start_y + add_y, content[iter * 3 + 1], content[iter * 3 + 2])

func from_tilemap(x: int, y: int):
	var start_x: int = (x << self.CHUNK_SIZE_X_POW) - 1
	var start_y: int = (y << self.CHUNK_SIZE_Y_POW) - 1
	var ret: PackedByteArray = []
	for add_y in range(self.CHUNK_SIZE_Y):
		for add_x in range(self.CHUNK_SIZE_X):
			var tile = Vector2(start_x + add_x, start_y + add_y)
			ret.append(placing.get_cell_atlas_coords(0, tile).x)
			ret.append(0)
			ret.append(0)
			placing.erase_cell(0, tile)
	var upper_bound: int = start_y * tile_size_y
	var lower_bound: int = (start_y + self.CHUNK_SIZE_Y) * tile_size_y
	var left_bound: int = start_x * tile_size_x
	var right_bound: int = (start_x + self.CHUNK_SIZE_X) * tile_size_x
	for monster_it in range(GlobalVariables.monsters.size() - 1, -1, -1):
		var monster = GlobalVariables.monsters[monster_it]
		if monster == null:
			GlobalVariables.monsters.remove_at(monster_it)
		else:
			var monster_coords: Vector2i = monster.get_position()
			if left_bound <= monster_coords.x and monster_coords.x < right_bound and upper_bound <= monster_coords.y and monster_coords.y < lower_bound:
				var where: int = (((monster_coords.y - upper_bound) / tile_size_y) * self.CHUNK_SIZE_X + ((monster_coords.x - left_bound) / tile_size_x)) * 3
				ret[where + 1] = monster.get_id()
				ret[where + 2] = monster.Hp
				GlobalVariables.monsters.remove_at(monster_it)
				monster.queue_free()
	return ret

func spawn(who: PackedScene, pos: Vector2, hp: int = 100):
	var instance = who.instantiate()
	instance.set_position(pos)
	instance.Hp = hp
	add_child(instance)
	GlobalVariables.monsters.append(instance)

func spawn_monster(x: int, y: int, id: int, hp: int):
	var monster: PackedScene
	match id:
		1:
			monster = wizardNode
		2:
			monster = warriorNode
		_:
			return
	spawn(monster, Vector2(x + 0.2, y + 0.2) * tile_size_x, hp)

func freeze_monsters():
	for monster in GlobalVariables.monsters:
		if monster != null:
			if (player.get_position() - monster.get_position()).length() > (
					self.CHUNK_SIZE_X * tile_size_x * 1.5 ):
				monster.process_mode = PROCESS_MODE_DISABLED
			else:
				monster.process_mode = PROCESS_MODE_INHERIT

func _ready():
	$"../AudioStreamPlayer".play()
	# Старт открытого мира, возвращает координаты игрока
	player.position = self.start(GlobalVariables.CurrentWorld, tile_size_x, tile_size_y)
	# Загрузка списка анимаций из специальной строго типизированной таблицы
	GlobalVariables.animations_list = self.get_animations()
	# Отладочный вывод содержания
	print("Loaded animations_list: ", GlobalVariables.animations_list)
	# При первом запуске пустой словарь
	if GlobalVariables.animations_list.is_empty():
		GlobalVariables.animations_list["Чё за хуйня?"] = 228
	# А теперб вариант для альтушек
	# Загрузка списка анимаций по ключу из кучи прочих данных, строгой типизации нет
	smth_saved = self.load_by("animations_list")
	# Отладочный вывод содержания
	print("Loaded example: ", smth_saved)
	# При первом запуске по ключу ничего не хранится (nil), а не пустой словарь
	if !smth_saved:
		smth_saved = { "Чё за хуйня?": 228 }

func _physics_process(_delta):
	freeze_monsters()
	self.set_view_center(player.position.x, player.position.y, false)
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
			# Отладочный вывод варианта строгой типизации
			print("Saved animations_list: ", GlobalVariables.animations_list)
			# Отладочный вывод альтушек (проверка содержания и типа данных)
			print("Saved example: ", smth_saved)
			print("Type of mem: ", typeof(smth_saved["Чё за хуйня?"]))
			# Сохранение списка анимаций в кучу без строгой типизации
			self.save_as("animations_list", smth_saved)
			# Выход из открытого мира пока принимает список анимаций для сохранения в строгой таблице
			self.exit(player.position, GlobalVariables.animations_list)
			# Сохранение
			unload_all()
