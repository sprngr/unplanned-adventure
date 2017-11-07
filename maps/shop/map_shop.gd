extends TileMap

onready var grid = get_parent()

# Tile mapping to enum
enum TILES {
	GRASS,
	ROAD,
	BUSH
}

# Map grid size
const GRID_SIZE = Vector2(30,20)

# Tile info
const IMPASSABLE = [BUSH]
const ENCOUNTERABLE = []

const PLAYER_SPAWN = Vector2(14,18)

var warp_tiles = {
	warp_0 = {
		coords = Vector2(13,19),
		target = "overworld/map_overworld"
	},
	warp_1 = {
		coords = Vector2(14,19),
		target = "overworld/map_overworld"
	},
	warp_2 = {
		coords = Vector2(15,19),
		target = "overworld/map_overworld"
	}
}