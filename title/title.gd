extends Node

func _ready():
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		globals.current_map = "overworld/map_overworld"
		get_node("/root/globals").set_scene("res://grid/grid.tscn")
