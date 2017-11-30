extends TileMap

# Map grid size
const GRID_SIZE = Vector2(30,21)

# Tile info
var passable = ["grass", "dirt"]
var encounterable = []

# Warp Info
# Sets up 3 tiles to send player back to overworld
var warp_tiles = {
	gate_0 = {
		coords = Vector2(14,19),
		target = null,
		link = null
	},
	exit_0 = {
		coords = Vector2(13,20),
		target = "overworld",
		link = "town_0"
	},
	exit_1 = {
		coords = Vector2(14,20),
		target = "overworld",
		link = "town_0"
	},
	exit_2 = {
		coords = Vector2(15,20),
		target = "overworld",
		link = "town_0"
	}
}