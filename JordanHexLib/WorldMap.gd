extends Node

var HexGrid = preload("res://HexGrid.gd").new()

onready var cursor = get_node("Cursor")

func _ready():
	HexGrid.hex_scale = Vector2(69, 61) # worked out the scaling factor by trial and error
	#cursor.position = Vector2(0, 0)

func _input(event):
	#if event is InputEventMouseButton:
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var mouse_pos = get_viewport().get_mouse_position()
		print("Raw cursor position" + str(mouse_pos))
		
		var hex_coords = HexGrid.get_hex_at(mouse_pos).axial_coords
		print("Axial Hex Coords: " + str(hex_coords))
		
		var cube_coords = HexGrid.get_hex_at(mouse_pos).cube_coords
		print("Cube Hex Coords: " + str(cube_coords))
		
		var offset_coords = HexGrid.get_hex_at(mouse_pos).offset_coords
		print("Offset Hex Coords: " + str(offset_coords))
		print("")
		

func _unhandled_input(event):
	if event.position:
		if cursor != null:
			cursor.position = HexGrid.get_hex_centre(HexGrid.get_hex_at(event.position))