extends Resource

const size = Vector2(1, sqrt(3)/2)

const DIR_NE = Vector3(1, 0, -1)
const DIR_E = Vector3(1, -1, 0)
const DIR_SE = Vector3(0, -1, 1)
const DIR_SW = Vector3(-1, 0, 1)
const DIR_W = Vector3(-1, 1, 0)
const DIR_NW = Vector3(0, 1, -1)
const DIR_ALL = [DIR_NE, DIR_E, DIR_SE, DIR_SW, DIR_W, DIR_NW]

var cube_coords = Vector3(0, 0, 0) setget set_cube_coords, get_cube_coords
var axial_coords setget set_axial_coords, get_axial_coords
var offset_coords setget set_offset_coords, get_offset_coords

func _init(coords=null):
	if coords:
		self.cube_coords = obj_to_coords(coords)
	
func new_hex(coords):
	#Returns a new HexCell instance
	return get_script().new(coords)

"""
Coordinate functions. Cube coords are canonical and are stored, but it is possible to use axial and offset (Odd-R) and convert back
"""


func obj_to_coords(val):
	
	if typeof(val) == TYPE_VECTOR3:
		return val
	elif typeof(val) == TYPE_VECTOR2:
		return axial_to_cube_coords(val)
	elif typeof(val) == TYPE_OBJECT and val.has_method("get_cube_coords"):
		return val.get_cube_coords()
	
	return

func axial_to_cube_coords(val):
	return Vector3(val.x, val.y, -val.x - val.y)

func round_coords(coords):
	if typeof(coords) == TYPE_VECTOR2:
		coords = axial_to_cube_coords(coords)
	
	var rounded = Vector3(round(coords.x), round(coords.y), round(coords.z))
	
	var diffs = (rounded - coords).abs()
	if diffs.x > diffs.y and diffs.x > diffs.z:
		rounded.x = -rounded.y - rounded.z
	elif diffs.y > diffs.z:
		rounded.y = -rounded.x - rounded.z
	else:
		rounded.z = -rounded.x - rounded.y
	
	return rounded

func get_cube_coords():
	return cube_coords

func set_cube_coords(coords):
	if abs(coords.x + coords.y + coords.z) > 0.0001:
		print("Warning: invalid cube coords for hex (x+y+z!=0): ", coords)
		return
	cube_coords = round_coords(coords)

func get_axial_coords():
	return Vector2(cube_coords.x, cube_coords.y)

func set_axial_coords(coords):
	set_cube_coords(axial_to_cube_coords(coords))


# Here we use the even-r offset coordinate system with the x flipped so that it produces a positive result when moving left
func get_offset_coords():
	var x = int(cube_coords.x)
	var y = int(cube_coords.y)
	var off_x = x + (y + (y & 1)) / 2
	return Vector2(-off_x, y)


func set_offset_coords(coords):
	var x = int(coords.x)
	var y = int(coords.y)
	var off_x = x - (y + (y & 1)) / 2
	self.set_cube_coords(-off_x, y, -off_x - y)



"""
Neighbourhood Functions
"""

func get_adjacent(dir):
	if typeof(dir) == TYPE_VECTOR2:
		dir = axial_to_cube_coords(dir)
	return new_hex(self.cube_coords + dir)

func get_all_adjacent(dir):
	var cells = Array()
	for dir in DIR_ALL:
		cells.append(new_hex(self.cube_coords + dir))

func get_all_within(distance):
	var cells = Array()
	for dx in range(-distance, distance + 1):
		for dy in range(max(-distance, -distance - dx), min(distance, distance - dx) + 1):
			cells.append(new_hex(self.axial_coords + Vector2(dx, dy)))
	return cells

func get_ring(radius):
	if radius < 1:
		return [new_hex(self.cube_coords)]
	
	var cells = Array()
	var current = new_hex(self.cube_coords + (DIR_NE * radius))
	for dir in [DIR_SE, DIR_SW, DIR_W, DIR_NW, DIR_NE, DIR_E]:
		for step in range(radius):
			cells.append(current)
			current = current.get_adjacent(dir)
	return cells

func distance_to(target):
	target = obj_to_coords(target)
	return (abs(cube_coords.x - target.x) + abs(cube_coords.y - target.y) + abs(cube_coords.z - target.z)) / 2

func line_to(target):
	target = obj_to_coords(target)
	
	var nudged_target = target + Vector3(1e-6, 2e-6, 3e-6)
	var steps = distance_to(target)
	var path = []
	for dist in range(steps):
		var lerped = cube_coords.linear_interpolate(nudged_target, dist / steps)
		path.append(new_hex(round_coords(lerped)))
	path.append(new_hex(target))
	return path





























