extends Node2D

enum EVENT_TYPES {
    BATTLE,
    DIALOGUE
}

var event_dict = {}
var event_data = {
    info = {},
    entity = {}
}
var event_state
var target_dict

onready var entity_frame = get_node("entity_frame")
onready var event_textbox = get_node("event_textbox")
onready var battle_textbox = get_node("battle_textbox")

func _ready():
    handle_event()
    load_event_dict()

    # Assemble event_data
    event_data.entity = event_dict[event_data.info.entity]

    # Setup entity frame, if needed
    entity_frame.setup()

    # Run dialogue if needed
    #event_textbox.setup()

    # Setup battle controls if needed
    battle_textbox.setup()

func handle_event():
    event_data.info = globals.get("event")

    if event_data.info.type == "battle":
        event_state = EVENT_TYPES.BATTLE
        target_dict = "monsters"

func load_event_dict():
    var file = File.new()
    file.open("res://events/data/" + target_dict + ".json", file.READ)

    var text = file.get_as_text()
    event_dict = parse_json(text)
    file.close()
