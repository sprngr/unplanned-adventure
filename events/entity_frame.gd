extends NinePatchRect

var event
var event_info
onready var background = get_node("entity_background")
onready var sprite = get_node("entity_sprite")

# Sets up logic around displaying the texture frames for battle
func _ready():
	event = get_parent()

func setup():
	event_info = event.event_data.info
	
	if event.event_state == event.BATTLE:
		set_background()
		set_sprite("monsters")
		
		self.show()
		
func set_background():
	var texture = load("res://assets/backgrounds/" + event_info.field + ".png")
	background.set_texture(texture)
	
func set_sprite(type):
	var texture = load("res://assets/" + type + "/" + event_info.entity + ".png")
	sprite.set_texture(texture)