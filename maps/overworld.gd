extends TileMap

onready var grid = get_parent()

# Tile mapping to enum
enum TILES {
	GRASS,
	DIRT,
	WATER
}

# Map grid size
const GRID_SIZE = Vector2(60,40)

# Tile info
const PASSABLE = [GRASS, DIRT]
const ENCOUNTERABLE = [GRASS, DIRT]

const PLAYER_SPAWN = Vector2(4,4)




