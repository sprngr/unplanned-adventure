extends Node2D

var dict = {}
var event_info
var event_data
var target_dict

func _ready():
	handle_event()
	load_event_data()
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		globals.store("state", "GAME_IS_PLAYING")
		self.queue_free()
		
func handle_event():
	event_info = globals.get("event")
	
	if event_info.type == "battle":
		target_dict = "monsters"
	
func load_event_data():
	var file = File.new()
	file.open("res://events/data/" + target_dict + ".json", file.READ)
	
	var text = file.get_as_text()
	dict.parse_json(text)
	file.close()
	
	event_info

