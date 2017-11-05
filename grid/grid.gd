extends TileMap

enum ENTITY_TYPES {
	PLAYER,
	WARP,
	PICKUP,
	ACTIONABLE
}

onready var window_size = OS.get_window_size()

# Grid Info
var tile_size = get_cell_size()
var half_tile_size = tile_size / 2
var grid_size = Vector2()
var grid = []
var positions = []

# Player
onready var Player = preload("res://player/player.tscn")
var player
var player_world_pos

# Map Info
onready var Overworld = preload("res://maps/overworld/map_overworld.tscn")
var map
var tiles_impassable


func _ready():
	load_map(Overworld)

	# Populate grid array with null values
	for x in range(grid_size.x):
		grid.append([])

		for y in range(grid_size.y):
			grid[x].append(null)

	spawn_player()
	
	# Add some crap to the grid as well
	# for n in range(5):
	# 	var grid_pos = Vector2(randi() % int(grid_size.x) - 1, randi() % int(grid_size.y) - 1)
	# 	if not grid_pos in positions:
	# 		positions.append(grid_pos)
    #
	# for pos in positions:
	# 	var new_obstacle = Obstacle.instance()
	# 	new_obstacle.set_pos(map_to_world(pos) + half_tile_size)
	# 	grid[pos.x][pos.y] = OBSTACLE
	# 	add_child(new_obstacle)

func is_cell_passable(pos, direction):
	var grid_pos = world_to_map(pos) + direction
	var tile = map.get_cellv(grid_pos)
	
	# Check if cell is passable (grass, dirt, etc)
	var is_passable = !tiles_impassable.has(tile)
	
	print("Tile:", tile, is_passable)

	# If yes, check to see if anything is currently at that pos
	if is_passable:
		if grid_pos.x < grid_size.x and grid_pos.x >= 0:
			if grid_pos.y < grid_size.y and grid_pos.y >= 0:
				return true if grid[grid_pos.x][grid_pos.y] == null else false
		return false
	else:
		return false

func load_map(scene):
	# Load in map
	map = scene.instance()
	map.set_pos(Vector2(0,0))
	# Add to scene
	add_child(map)
	
	# Populate needed values from child map
	grid_size = map.GRID_SIZE
	tiles_impassable = map.IMPASSABLE

func spawn_player():
	player = Player.instance()
	player_world_pos = map_to_world(map.PLAYER_SPAWN) + half_tile_size
	player.set_pos(player_world_pos)
	add_child(player)
	update_camera()
	
func update_child_pos(child_node):
	var grid_pos = world_to_map(child_node.get_pos())
	print("Pos", grid_pos)
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
		get_viewport().set_canvas_transform(transform)