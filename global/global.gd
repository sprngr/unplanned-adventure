extends Node

var current_scene = null
var game_data = {}

func _ready():
	current_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)

func get(key):
	return game_data[key]
	
func initialize():
	# TODO Load in save data first before loading default values
	game_data.state = null
	game_data.map = {
		id = "overworld",
		spawn = "game_start"
	}
	
func set_scene(scene):
	var new_scene = ResourceLoader.load(scene)
	current_scene.queue_free()
	current_scene = new_scene.instance()
	get_tree().get_root().add_child(current_scene)
	
func store(key, data):
	game_data[key] = data