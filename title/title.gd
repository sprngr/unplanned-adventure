extends Node

var cursor_pos = 0
var save_file_exists = false

# Menu items
var label_continue = "Continue"
var label_new_game = "New Game"
var label_arr = [label_continue, label_new_game]

# Get child text nodes first so we can hide/select them as needed
onready var menu_continue = get_node("text_continue")
onready var menu_new_game = get_node("text_new_game")
onready var menu_arr = [menu_continue, menu_new_game]

func _ready():
	set_process_input(true)
	
	# Check if a save exists, default to continue; otherwise hide it and select New Game.
	save_file_exists = File.new().file_exists("user://unplanned_save.save")
	
	if !save_file_exists:
		select_menu_item(menu_new_game)
	else:
		select_menu_item(menu_continue)

func select_menu_item(menu_item):
	menu_item.clear()
	menu_item.append_bbcode("[center][color=#000000]" + label_arr[cursor_pos] + "[/color][/center]")
	menu_item.pop()
	
	for i in range(menu_arr.size()):
		if i != cursor_pos:
			menu_arr[i].clear()
			menu_arr[i].append_bbcode("[center][color=#a5a5a5]" + label_arr[i] + "[/color][/center]")
			menu_arr[i].pop()
	
func _input(event):
	
	# When player hits accept key, initialize game data with loaded game or new game
	if save_file_exists and (event.is_action_pressed("move_up") or event.is_action_pressed("move_down")):
		cursor_pos = (cursor_pos + 1) % menu_arr.size()
		select_menu_item(menu_arr[cursor_pos])
	
	# In the future we'll want to check if we're loading an exisiting save
	if event.is_action_pressed("ui_accept"):
		globals.initialize()
		globals.set_scene("res://grid/grid.tscn")