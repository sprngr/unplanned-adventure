extends TileMap

# Map grid size
const GRID_SIZE = Vector2(30,21)

# Tile info
var passable = ["cave-floor", "dirt", "cave-exit-m", "cave-exit-l", "cave-exit-r", "cave-stairs"]
var encounterable = ["cave-floor", "dirt"]

# Warp Info
# Sets up 3 tiles to send player back to overworld
var warp_tiles = {
	door_1 = {
		coords = Vector2(14,1),
		target = null,
		link = null
	},
	exit_0 = {
		coords = Vector2(13,0),
		link = "dunegon_1",
		target = "overworld"
	},
	exit_1 = {
		coords = Vector2(14,0),
		link = "dunegon_1",
		target = "overworld"
	},
	exit_2 = {
		coords = Vector2(15,0),
		link = "dunegon_1",
		target = "overworld"
	},
	stairs_2 = {
		coords = Vector2(25,2),
		link = "stairs_2",
		target = "dungeon_1"
	}
}

var encounters = [
	{
		entity = "goblin",
		field = "cave",
		level = 3,
		type = "battle"
	},
	{
		entity = "red slime",
		field = "cave",
		level = 3,
		type = "battle"
	}
]