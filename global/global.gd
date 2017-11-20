extends Node

var current_scene = null
var game_data = {}

func _ready():
	# Set a new random seed
	randomize()
	
	# Set current scene
	current_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)

func get(key):
	return game_data[key]
	
func initialize():
	# TODO Load in save data first before loading default values
	
	game_data = {
		player_direction = Vector2(),
		player_position = Vector2(),
		viewport = Vector2(),
		state = "GAME_PLAYING",
		map = {
			id = "overworld",
			spawn = "game_start"
		}
	}

func load_save():
	pass
	
func prepare_save():
	var save_dict = {
		map = game_data.map.id,
		player_direction = {
			x = game_data.player_direction.x,
			y = game_data.player_direction.y
		},
		player_position = {
			x = game_data.player_position.x,
			y = game_data.player_position.y
		},
		state = game_data.state,
		viewport = {
			x = game_data.viewport.x,
			y = game_data.viewport.y
		}
	}
	return save_dict
	
func save_game():
	var savegame = File.new()
	savegame.open("user://unplanned_save.save", File.WRITE)
	savegame.store_line(prepare_save().to_json())
	savegame.close()

func set_scene(scene):
	var new_scene = ResourceLoader.load(scene)
	current_scene.queue_free()
	current_scene = new_scene.instance()
	get_tree().get_root().add_child(current_scene)
	
func store(key, data):
	game_data[key] = data