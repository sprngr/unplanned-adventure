extends TileMap

enum ENTITY_TYPES {
	PLAYER,
	WARP,
	PICKUP,
	ACTIONABLE
}

onready var window_size = Vector2(Globals.get("display/width"), Globals.get("display/height"))

# Grid Info
var tile_size = get_cell_size()
var half_tile_size = tile_size / 2
var grid_size = Vector2()
var grid = []
var grid_warps

# Player
onready var Player = preload("res://player/player.tscn")
var player
var player_world_pos

# Random Events
var event

# Map Info
var map
var map_warps = {}
var tileset
var tiles_passable
var tiles_encounterable

func _ready():
	initialize()
	globals.store("state", "GAME_IS_PLAYING")

func is_cell_passable(pos, direction):
	var grid_pos = world_to_map(pos) + direction
	var tile = map.get_cellv(grid_pos)
	var target_tile = tileset.tile_get_name(tile)
	
	# Check if cell is passable (grass, dirt, etc)
	var is_passable = tiles_passable.has(target_tile)
	var is_encounterable = tiles_encounterable.has(target_tile)

	# If yes, check to see if anything is currently at that pos
	if is_passable:
		if grid_pos.x < grid_size.x and grid_pos.x >= 0:
			if grid_pos.y < grid_size.y and grid_pos.y >= 0:
				if grid_warps[grid_pos.x][grid_pos.y] != null and grid_warps[grid_pos.x][grid_pos.y] != 0:
					warp_player(grid_warps[grid_pos.x][grid_pos.y].key)
					return false
					
				if grid_warps[grid_pos.x][grid_pos.y] == null && grid[grid_pos.x][grid_pos.y] == null:
					if is_encounterable:
						var random = randi() % 100
						if random <= 24:
							random_encounter()
							return false
					return true

	return false

func random_encounter():
	# Load in event
	var scene = ResourceLoader.load("res://events/event.tscn")
	event = scene.instance()
	event.set_pos(globals.get("viewport"))
	
	# Add to scene
	add_child(event)
	globals.store("state", "GAME_EVENT")
	
func warp_player(key):
	var target_scene = map.warp_tiles[key]
	# Set game state to "player is warping"
	# This should kill all momentum until screen has loaded
	# We don't want to update this until they press forward
	globals.store("state", "GAME_WARPING")
	
	# Load in new map data pulled from child scene
	mapManager.load_map(target_scene)
	
# initialize
# This sets up all the data based on the current game state
func initialize():
	# Load in map
	var scene = ResourceLoader.load(mapManager.get_map_resource())
	map = scene.instance()
	map.set_pos(Vector2(0,0))
	
	# Add to scene
	add_child(map)
	
	# Store tileset
	tileset = map.get_tileset()
	
	# Populate needed values from child map
	grid_size = map.GRID_SIZE
	
	# Reset grid back to null values
	for x in range(grid_size.x):
		grid.append([])
		
		for y in range(grid_size.y):
			grid[x].append(null)
			
	# Clone grid for grid_warps array
	grid_warps = [] + grid
			
	tiles_passable = map.passable
	tiles_encounterable = map.encounterable
	
	var warp_tiles = map.warp_tiles
	for key in warp_tiles:
		var coords = warp_tiles[key].coords
		
		# Store a copy of the warp tiles coords by ID for reference when spawning player
		map_warps[key] = {
			coords = Vector2(coords.x, coords.y)
		}
		
		# Store references to map warp tiles
		if warp_tiles[key].target != null:
			grid_warps[coords.x][coords.y] = {
				type = WARP,
				key = key
			}
	
	spawn_player()

func spawn_player():
	var spawn_pos = mapManager.get_spawn()
	player = Player.instance()
	player_world_pos = map_to_world(map_warps[spawn_pos].coords) + half_tile_size
	player.set_pos(player_world_pos)
	add_child(player)
	update_camera()
	
func update_child_pos(child_node):
	var grid_pos = world_to_map(child_node.get_pos())
	
	if (grid_warps[grid_pos.x][grid_pos.y] == null or grid_warps[grid_pos.x][grid_pos.y] == 0):
		grid[grid_pos.x][grid_pos.y] = null

	var new_grid_pos = grid_pos + child_node.direction
	grid[new_grid_pos.x][new_grid_pos.y] = child_node.type
	
	var target_pos = map_to_world(new_grid_pos) + half_tile_size
	
	if (child_node.type == PLAYER):
		player_world_pos = target_pos

	return target_pos

func get_player_world_pos():
	var pos = player.get_pos()
	var x = floor(pos.x / window_size.x)
	var y = floor(pos.y / window_size.y)
	
	return Vector2(x,y)
	
func update_camera():
	var new_player_grid_pos = get_player_world_pos()
	var transform = Matrix32()
	
	if new_player_grid_pos != player_world_pos:
		player_world_pos = new_player_grid_pos
		transform = get_viewport().get_canvas_transform()
		transform[2] = -player_world_pos * window_size
		globals.store("viewport", transform[2].abs())
		get_viewport().set_canvas_transform(transform)