extends Node2D

var world_size : Vector2 = Vector2(4, 4)
var rooms
var taken_positions : Array[Vector2]
var grid_size_x : int
var grid_size_y : int
var number_of_rooms = 20
var room_white_obj

func _ready():
	print("*************************************")
	rooms_and_grid_init()
	create_rooms()
	set_room_doors()
	draw_map()

func _process(delta):
	if Input.is_action_just_pressed("rebuild"):
		print("*************************************")
		rooms_and_grid_init()
		create_rooms()
		set_room_doors()
		draw_map()

func rooms_and_grid_init():
	if (number_of_rooms >= (world_size.x * 2) * (world_size.y * 2)):
		number_of_rooms = roundi((world_size.x * 2) * (world_size.y * 2))
	grid_size_x = roundi(world_size.x)
	grid_size_y = roundi(world_size.y)

func create_rooms():
	_rooms_setup()
	_add_rooms()

func _rooms_setup():
	rooms = []
	taken_positions = []
	for col in range(grid_size_x * 2):
		rooms.append([])
		for row in range(grid_size_y * 2):
			rooms[col].append(null)
	rooms[grid_size_x][grid_size_y] = Room.new(Vector2.ZERO, 1)
	taken_positions.insert(0, Vector2.ZERO)

func _add_rooms():
	randomize()
	var check_pos = Vector2.ZERO
	# magic numbers
	var random_compare = 0.2
	var random_compare_start = 0.2
	var random_compare_end = 0.01
	for i in range(0, number_of_rooms - 1):
		var random_perc = float(i)/float(number_of_rooms-1)
		random_compare = lerp(random_compare_start, random_compare_end, random_perc)
		# grab new position
		check_pos = _new_position()
		# test new position
		if _number_of_neighbors(check_pos, taken_positions) > 1 and randf() > random_compare:
			var iterations = 0
			check_pos = _selective_new_position()
			iterations += 1
			while _number_of_neighbors(check_pos, taken_positions) > 1 and iterations < 100:
				check_pos = _selective_new_position()
				iterations += 1
			if iterations >= 50:
				print("error: could not create with fewer neighbors than : " + str(_number_of_neighbors(check_pos, taken_positions)))
		rooms[int(check_pos.x + grid_size_x)][int(check_pos.y + grid_size_y)] = Room.new(check_pos, 0)
		taken_positions.insert(0, check_pos)

func _new_position():
	var x = 0
	var y = 0
	var checking_pos = Vector2.ZERO
	while checking_pos in taken_positions or x >= grid_size_x or x < -grid_size_x or y >= grid_size_y or y < -grid_size_y:
		var index = roundi(randf() * (taken_positions.size() - 1))
		x = int(taken_positions[index].x)
		y = int(taken_positions[index].y)
		var up_down : bool = (randf() < 0.5)
		var positive : bool = (randf() < 0.5)
		if up_down:
			if positive:
				y += 1
			else:
				y -= 1
		else:
			if positive:
				x += 1
			else:
				x -= 1
		checking_pos = Vector2(x, y)
	return checking_pos

func _selective_new_position():
	var index = 0
	var inc = 0
	var x = 0
	var y = 0
	var checking_pos = Vector2.ZERO
	while checking_pos in taken_positions or x >= grid_size_x or x < -grid_size_x or y >= grid_size_y or y < -grid_size_y:
		inc = 0
		while _number_of_neighbors(taken_positions[index], taken_positions) > 1 and inc < 100:
			index = roundi(randf() * (taken_positions.size() - 1))
			inc += 1
		x = int(taken_positions[index].x)
		y = int(taken_positions[index].y)
		var up_down : bool = (randf() < 0.5)
		var positive : bool = (randf() < 0.5)
		if up_down:
			if positive:
				y += 1
			else:
				y -= 1
		else:
			if positive:
				x += 1
			else:
				x -= 1
		checking_pos = Vector2(x, y)
	if inc >= 100:
		print("Error: could not find position with only one neighbor")
	return checking_pos

func _number_of_neighbors(check_pos, taken_positions):
	var ret = 0
	if (check_pos + Vector2.RIGHT) in taken_positions:
		ret += 1
	if (check_pos + Vector2.LEFT) in taken_positions:
		ret += 1
	if (check_pos + Vector2.UP) in taken_positions:
		ret += 1
	if (check_pos + Vector2.DOWN) in taken_positions:
		ret += 1
	return ret

func set_room_doors():
	for x in range(grid_size_x * 2):
		for y in range(grid_size_y * 2):
			if rooms[x][y] == null:
				continue
			var grid_position = Vector2(x, y)
			if (y-1 < 0):
				rooms[x][y].Doors["bot"] = false
			else:
				rooms[x][y].Doors["bot"] = (rooms[x][y-1] != null)
			if (y+1 >= grid_size_y * 2):
				rooms[x][y].Doors["top"] = false
			else:
				rooms[x][y].Doors["top"] = (rooms[x][y+1] != null)
			if (x-1 < 0):
				rooms[x][y].Doors["left"] = false
			else:
				rooms[x][y].Doors["left"] = (rooms[x-1][y] != null)
			if (x+1 >= grid_size_x * 2):
				rooms[x][y].Doors["right"] = false
			else:
				rooms[x][y].Doors["right"] = (rooms[x+1][y] != null)

func draw_map():
	for col in range(grid_size_x * 2):
		var s = ""
		for raw in range(grid_size_y * 2):
			if rooms[col][raw] == null:
				s += str(0)
			else:
				s += str(1)
		print(s)
