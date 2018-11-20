extends Area2D

var HexGrid = preload("res://HexGrid.gd").new()

onready var hex_tracker = get_node("HexTracker")
onready var origin = get_node("Origin")
onready var pixel_coords = get_node("HexTracker/PixelCoords")
onready var hex_coords = get_node("HexTracker/HexCoords")


func _ready():
	HexGrid.hex_scale = Vector2(50,50)

func _unhandled_input(event):
	if event.position:
		var relative_pos = self.transform.affine_inverse() * event.position
		
		if pixel_coords != null:
			pixel_coords.text = str(relative_pos)
		if hex_coords != null:
			hex_coords.text = str(HexGrid.get_hex_at(relative_pos).axial_coords)
		
		if hex_tracker != null:
			hex_tracker.position = HexGrid.get_hex_centre(HexGrid.get_hex_at(relative_pos))
		if origin != null:
			origin.position = HexGrid.get_hex_centre(Vector3(0,0,0))
			$Origin/PixelCoords.text = str(HexGrid.get_hex_centre(Vector3(0,0,0)))
			$Origin/HexCoords.text = "0,0"