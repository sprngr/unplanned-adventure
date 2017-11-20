extends TileMap

# Map grid size
const GRID_SIZE = Vector2(90,65)

# Tile Info
var passable = ["grass", "dirt"]
var encounterable = ["grass"]

# Warp Info
var warp_tiles = {
	game_start = {
		coords = Vector2(15,9),
		link = null,
		target = null
	},
	town_0 = {
		coords = Vector2(27,6),
		link = "gate_0",
		target = "shop"
	}
}

var encounters = {
	monster_0 = {
		type: "battle",
		level: 1,
		entity: "slime",
	}
}
