extends Resource

var HexCell = preload("res://HexCell.gd")

const DIR_NE = Vector3(1, 0, -1)
const DIR_E = Vector3(1, -1, 0)
const DIR_SE = Vector3(0, -1, 1)
const DIR_SW = Vector3(-1, 0, 1)
const DIR_W = Vector3(-1, 1, 0)
const DIR_NW = Vector3(0, 1, -1)
const DIR_ALL = [DIR_NE, DIR_E, DIR_SE, DIR_SW, DIR_W, DIR_NW]

export(Vector2) var hex_scale = Vector2(1, 1) setget set_hex_scale

var base_hex_size = Vector2(sqrt(3)/2, 1)
var hex_size
var hex_transform
var hex_transform_inv

func _init():
	set_hex_scale(hex_scale)
	

func set_hex_scale(scale):
	
	hex_scale = scale
	hex_size = base_hex_size * hex_scale
	hex_transform = Transform2D(
		Vector2(-hex_size.x * sqrt(3) / 2, 0),
		Vector2(-hex_size.x * sqrt(3) / 4, hex_size.y * 3 / 4),
		Vector2(0, 0)
	)
	hex_transform_inv = hex_transform.affine_inverse()

"""
Convert between hex grid and 2D spatial coords
"""

func get_hex_centre(hex):
	hex = HexCell.new(hex)
	return hex_transform * hex.axial_coords

func get_hex_at(coords):
	return HexCell.new(hex_transform_inv * coords)

