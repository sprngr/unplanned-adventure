extends Node2D

var event_dict = {}
var event_data = {
	info = {},
	entity = {}
}
var target_dict

func _ready():
	handle_event()
	load_event_data()

	# Assemble event_data
	event_data.entity = event_dict[event_data.info.entity]

	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		globals.store("state", "GAME_IS_PLAYING")
		self.queue_free()

func handle_event():
	event_data.info = globals.get("event")

	if event_data.info.type == "battle":
		target_dict = "monsters"

func load_event_dict():
	var file = File.new()
	file.open("res://events/data/" + target_dict + ".json", file.READ)

	var text = file.get_as_text()
	event_dict.parse_json(text)
	file.close()
