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

# Sets up 3 tiles to send player back to overworld
var warp_tiles = {
	gate_0 = {
		coords = Vector2(13,19),
		target = "overworld",
		link = "town_0"
	},
	gate_1 = {
		coords = Vector2(14,19),
		target = "overworld",
		link = "town_0"
	},
	gate_2 = {
		coords = Vector2(15,19),
		target = "overworld",
		link = "town_0"
	}
}