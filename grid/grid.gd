extends TileMap

var tile_size = get_cell_size()
var half_tile_size = tile_size / 2

enum ENTITY_TYPES {
	PLAYER,
	WARP,
	PICKUP,
	ACTIONABLE
}

var grid_size = Vector2()
var grid = []
var positions = []

var map
var tiles_passable

onready var Overworld = preload("res://maps/overworld.tscn")

onready var Player = preload("res://player/player.tscn")

func _ready():
	load_map(Overworld)

	for x in range(grid_size.x):
		grid.append([])

		for y in range(grid_size.y):
			grid[x].append(null)

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

func is_cell_vacant(pos, direction):
	var grid_pos = world_to_map(pos) + direction
	var tile = map.get_cellv(grid_pos)
	
	# Check if cell is passable (grass, dirt, etc)
	var is_passable = tiles_passable.has(tile)
	
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
	tiles_passable = map.PASSABLE

func spawn_player():
	var player = Player.instance()
	positions.append(Vector2(int(grid_size.x) / 2, int(grid_size.y) / 2))
	player.set_pos(map_to_world(positions[0]) + half_tile_size)
	grid[positions[0].x][positions[0].y] = PLAYER
	add_child(player)
	
func update_child_pos(child_node):
	var grid_pos = world_to_map(child_node.get_pos())
	print("Pos", grid_pos)
	grid[grid_pos.x][grid_pos.y] = null

	var new_grid_pos = grid_pos + child_node.direction
	grid[new_grid_pos.x][new_grid_pos.y] = child_node.type

	var target_pos = map_to_world(new_grid_pos) + half_tile_size
	return target_pos
