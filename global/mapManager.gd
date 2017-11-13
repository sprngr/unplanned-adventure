extends Node

# mapManager
# This script is intended to interface with globals.game_data.map to manage the
# current map and its spawn point

# map data schema
#{
#	id: string map name,
#	spawn: string id of warp to spawn player
#}

func get_map_resource():
	var map_id = globals.game_data.map.id
	return "res://maps/" + map_id + "/map_" + map_id + ".tscn"
	
func get_spawn():
	return globals.game_data.map.spawn

func load_map(scene):
	set_map(scene)
	globals.set_scene("res://grid/grid.tscn")
	
func set_map(data):
	var payload = {
		id = data.target,
		spawn = data.link
	}
	globals.store("map", payload);


