extends Node

enum WARP_TYPES {
	WARP,
	BACK_WARP,
	EXIT_WARP
}

# mapManager
# This script is intended to interface with globals.map_history to manage the
# past and present maps loaded and at what positions the player entered from.

# mapSchema
# 

func load_map(scene):
	globals.set_scene("res://grid/grid.tscn")

# Return last map stored in history
func get_last():
	pass

func push(map):
	pass

func pop():
	pass

func clear():

	pass
