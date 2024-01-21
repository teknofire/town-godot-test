extends Node2D

@onready var tile_map = $TileMap

var ground_layer = 1
var environment_layer = 2

var dirt_tiles = []

var can_place_seed_custom_data = "can_place_seeds"
var can_place_dirt_custom_data = "can_place_dirt"

enum FARM_MODES {SEED, DIRT}
var farm_mode = FARM_MODES.DIRT

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_custom_tile_data(layer, position, field):	
	var tile_data : TileData = tile_map.get_cell_tile_data(layer, position, false)
	if tile_data:
		return tile_data.get_custom_data(field)

func place_dirt(position, source_id):
	dirt_tiles.append(position)
	tile_map.set_cells_terrain_connect(ground_layer, dirt_tiles, 2, 0)


func handle_click():
	var mouse_pos = get_global_mouse_position()
	var tile_pos = tile_map.local_to_map(mouse_pos)
	var source_id = 0
	
	match farm_mode:
		FARM_MODES.DIRT:
			if get_custom_tile_data(ground_layer, tile_pos, can_place_dirt_custom_data):
				place_dirt(tile_pos, source_id)
				
		FARM_MODES.SEED:
			if get_custom_tile_data(ground_layer, tile_pos, can_place_seed_custom_data):
				var atlas_coord = Vector2i(11, 1)
				tile_map.set_cell(environment_layer, tile_pos, source_id, atlas_coord)
				
		_:
			print("can't place here")

func toggle_dirt():
	farm_mode = FARM_MODES.DIRT
	
func toggle_seed():
	farm_mode = FARM_MODES.SEED

func _input(event):
	if Input.is_action_just_pressed("toggle_dirt"):
		toggle_dirt()
	if Input.is_action_just_pressed("toggle_seed"):
		toggle_seed();
	if Input.is_action_just_pressed("click"):
		handle_click()
