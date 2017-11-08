extends Node

var current_scene = null
var current_map
var last_map
var last_overworld_pos

var map_history = []

func _ready():
	current_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)
	
func set_scene(scene):
	var new_scene = ResourceLoader.load(scene)
	
	current_scene.queue_free()
	current_scene = new_scene.instance()
	get_tree().get_root().add_child(current_scene)