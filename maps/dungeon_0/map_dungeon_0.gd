extends TileMap

# Map grid size
const GRID_SIZE = Vector2(30,21)

# Tile info
var passable = ["cave-floor", "dirt", "cave-exit-m", "cave-exit-l", "cave-exit-r", "cave-stairs"]
var encounterable = ["cave-floor", "dirt"]

# Warp Info
# Sets up 3 tiles to send player back to overworld
var warp_tiles = {
	door_0 = {
		coords = Vector2(14,19),
		target = null,
		link = null
	},
	exit_0 = {
		coords = Vector2(13,20),
		link = "dunegon_0",
		target = "overworld"
	},
	exit_1 = {
		coords = Vector2(14,20),
		link = "dunegon_0",
		target = "overworld"
	},
	exit_2 = {
		coords = Vector2(15,20),
		link = "dunegon_0",
		target = "overworld"
	},
	stairs_0 = {
		coords = Vector2(26,2),
		link = "stairs_1",
		target = "dungeon_1"
	}
}

var encounters = [
	{
		entity = "goblin",
		field = "cave",
		level = 1,
		type = "battle"
	},
	{
		entity = "slime",
		field = "cave",
		level = 1,
		type = "battle"
	}
]