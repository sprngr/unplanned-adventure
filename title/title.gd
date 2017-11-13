extends Node

func _ready():
	set_process(true)

func _process(delta):
	
	# When player hits accept key, initialize game data
	# In the future we'll want to check if we're loading an exisiting save
	if Input.is_action_pressed("ui_accept"):
		globals.initialize()
		get_node("/root/globals").set_scene("res://grid/grid.tscn")
