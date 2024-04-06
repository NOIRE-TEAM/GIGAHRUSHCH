extends WorldSaver

var placing
var player

func to_tilemap(x: int, y: int, content: PackedByteArray):
	var start_x: int = (x << self.CHUNK_SIZE_X_POW) - 1
	var start_y: int = (y << self.CHUNK_SIZE_Y_POW) - 1
	for add_y in range(self.CHUNK_SIZE_Y):
		for add_x in range(self.CHUNK_SIZE_X):
			if content[(add_y << self.CHUNK_SIZE_Y_POW) + add_x] > 32:
				placing.set_cell(0, Vector2(start_x + add_x, start_y + add_y), 0, Vector2i.ZERO)

func from_tilemap(x: int, y: int):
	var start_x: int = (x << self.CHUNK_SIZE_X_POW) - 1
	var start_y: int = (y << self.CHUNK_SIZE_Y_POW) - 1
	var ret: PackedByteArray = []
	for add_y in range(self.CHUNK_SIZE_Y):
		for add_x in range(self.CHUNK_SIZE_X):
			var tile = Vector2(start_x + add_x, start_y + add_y)
			if placing.get_cell_atlas_coords(0, tile).x >= 0:
				ret.append(33)
				placing.erase_cell(0, tile)
			else:
				ret.append(32)
	return ret

func _ready():
	player = get_child(0)
	placing = get_child(1)
	self.start("example", placing.tile_set.tile_size.x, placing.tile_set.tile_size.y)

func _physics_process(delta):
	self.set_view_center(player.position.x, player.position.y)
	var str: String = self.which_to_unload()
	while str.length() != 0:
		var fields = str.split("\t")
		var x = int(fields[0])
		var y = int(fields[1])
		var content = from_tilemap(x, y)
		self.unload(str + "\t" + content.get_string_from_ascii())
		str = self.which_to_unload()
	str = self.load_another_one()
	while str.length() != 0:
		var fields = str.split("\t")
		var x = int(fields[0])
		var y = int(fields[1])
		var content = fields[2].to_ascii_buffer()
		to_tilemap(x, y, content)
		str = self.load_another_one()
	if (Input.is_action_just_pressed("ui_attack")):
		var tile: Vector2 = placing.local_to_map(placing.get_global_mouse_position())
		placing.set_cell(0, tile, 0, Vector2i.ZERO)
	if (Input.is_action_just_pressed("ui_attack_2")):
		var tile : Vector2 = placing.local_to_map(placing.get_global_mouse_position())
		placing.erase_cell(0, tile)
