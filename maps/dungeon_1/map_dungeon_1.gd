extends TileMap

# Map grid size
const GRID_SIZE = Vector2(30,21)

# Tile info
var passable = ["cave-floor", "dirt", "cave-exit-m", "cave-exit-l", "cave-exit-r", "cave-stairs"]
var encounterable = ["cave-floor", "dirt"]

# Warp Info
# Sets up 3 tiles to send player back to overworld
var warp_tiles = {
	stairs_1 = {
		coords = Vector2(2,2),
		link = "stairs_0",
		target = "dungeon_0"
	},
	stairs_2 = {
		coords = Vector2(12,2),
		link = "stairs_2",
		target = "dungeon_2"
	}
}

var encounters = [
	{
		entity = "goblin",
		field = "cave",
		level = 2,
		type = "battle"
	},
	{
		entity = "bat",
		field = "cave",
		level = 1,
		type = "battle"
	}
]