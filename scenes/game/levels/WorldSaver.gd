extends WorldSaver

var placing
var player

func to_tilemap(x: int, y: int, content: PackedByteArray):
	var start_x: int = (x << self.CHUNK_SIZE_X_POW) - 1
	var start_y: int = (y << self.CHUNK_SIZE_Y_POW) - 1
	for add_y in range(self.CHUNK_SIZE_Y):
		for add_x in range(self.CHUNK_SIZE_X):
			if content[(add_y << self.CHUNK_SIZE_Y_POW) + add_x] == 1:
				placing.set_cell(0, Vector2(start_x + add_x, start_y + add_y), 0, Vector2i.ZERO)

func from_tilemap(x: int, y: int):
	var start_x: int = (x << self.CHUNK_SIZE_X_POW) - 1
	var start_y: int = (y << self.CHUNK_SIZE_Y_POW) - 1
	var ret: PackedByteArray = []
	for add_y in range(self.CHUNK_SIZE_Y):
		for add_x in range(self.CHUNK_SIZE_X):
			var tile = Vector2(start_x + add_x, start_y + add_y)
			if placing.get_cell_atlas_coords(0, tile).x >= 0:
				ret.append(1)
				placing.erase_cell(0, tile)
			else:
				ret.append(0)
	return ret

func _ready():
	player = get_child(0)
	placing = get_child(1)
	self.start("example", placing.tile_set.tile_size.x, placing.tile_set.tile_size.y)

func _physics_process(delta):
	self.set_view_center(player.position.x, player.position.y)
	var unload_xy: PackedInt64Array = self.which_to_unload()
	while !unload_xy.is_empty():
		var payload = unload_xy.to_byte_array()
		payload.append_array(from_tilemap(unload_xy[0], unload_xy[1]))
		self.unload(payload)
		unload_xy = self.which_to_unload()
	var payload: PackedByteArray = self.load_another_one()
	while !payload.is_empty():
		var fields = payload.slice(0, 16).to_int64_array()
		to_tilemap(fields[0], fields[1], payload.slice(16))
		payload = self.load_another_one()
	if (Input.is_action_just_pressed("ui_attack")):
		var tile: Vector2 = placing.local_to_map(placing.get_global_mouse_position())
		placing.set_cell(0, tile, 0, Vector2i.ZERO)
	if (Input.is_action_just_pressed("ui_attack_2")):
		var tile : Vector2 = placing.local_to_map(placing.get_global_mouse_position())
		placing.erase_cell(0, tile)
