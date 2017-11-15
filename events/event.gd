extends Node2D

func _ready():
	set_process_input(true)
	
func _input(event):
	if event.type == InputEvent.KEY and Input.is_action_pressed("ui_accept"):
		globals.store("state", "GAME_IS_PLAYING")
		self.queue_free()
