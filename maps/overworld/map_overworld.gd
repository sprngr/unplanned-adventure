extends TileMap

onready var grid = get_parent()

# Tile mapping to enum
enum TILES {
	GRASS,
	DIRT,
	WATER
}

# Map grid size
const GRID_SIZE = Vector2(90,65)

# Tile info
const IMPASSABLE = [WATER]
const ENCOUNTERABLE = [GRASS, DIRT]

const PLAYER_SPAWN = Vector2(15,9)

var warp_tiles = {
	warp_0 = {
		coords = Vector2(27,7),
		target = "shop/map_shop"
	},
	warp_1 = {
		coords = Vector2(28,7),
		target = "shop/map_shop"
	},
	warp_2 = {
		coords = Vector2(27,6),
		target = "shop/map_shop"
	},
	warp_3 = {
		coords = Vector2(28,6),
		target = "shop/map_shop"
	}
}




