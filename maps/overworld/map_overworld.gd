extends TileMap

onready var grid = get_parent()

# Tile mapping to enum
enum TILES {
	GRASS,
	DIRT,
	WATER,
	BUSH
	COAST0,
	COAST1,
	COAST2,
	COAST3,
	COAST4,
	COAST5,
	COAST6,
	COAST7,
	COAST8,
	COAST9,
	COASTA,
	COASTB
}

# Map grid size
const GRID_SIZE = Vector2(90,65)

# Tile info
const IMPASSABLE = [
	WATER, 
	BUSH,
	COAST0,
	COAST1,
	COAST2,
	COAST3,
	COAST4,
	COAST5,
	COAST6,
	COAST7,
	COAST8,
	COAST9,
	COASTA,
	COASTB
	]
const ENCOUNTERABLE = [GRASS, DIRT]

const PLAYER_SPAWN = Vector2(15,9)

var warp_tiles = {
	warp_0 = {
		coords = Vector2(27,6),
		exit = Vector2(14,18),
		target = "shop/map_shop"
	}
}
