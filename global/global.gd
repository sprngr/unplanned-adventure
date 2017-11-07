extends Node

var current_scene = null
var current_map
var last_map
var last_overworld_pos

func _ready():
	current_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)
	Globals.set("MAX_POWER_LEVEL", 9000)
	
func set_scene(scene):
	var new_scene = ResourceLoader.load(scene)
	
	current_scene.queue_free()
	current_scene = new_scene.instance()
	get_tree().get_root().add_child(current_scene)
	
func load_new_map():
	set_scene("res://grid/grid.tscn")