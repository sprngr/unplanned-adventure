extends TileMap

# Map grid size
const GRID_SIZE = Vector2(90,65)

# Tile Info
var passable = ["grass", "dirt", "mimic", "gold"]
var encounterable = ["grass"]

# Warp Info
var warp_tiles = {
	game_start = {
		coords = Vector2(33,34),
		link = null,
		target = null
	},
	dunegon_0 = {
		coords = Vector2(33,29),
		link = "door_0",
		target = "dungeon_0"
	},
	dunegon_1 = {
		coords = Vector2(31,19),
		link = "door_1",
		target = "dungeon_2"
	}
}

var encounters = [
	{
		entity = "slime",
		field = "grass",
		level = 1,
		type = "battle"
	},
	{
		entity = "goblin",
		field = "grass",
		level = 1,
		type = "battle"
	}
]
