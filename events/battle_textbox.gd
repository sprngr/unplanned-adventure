extends Patch9Frame

enum BATTLE_STATES {
	TEXT,
	COMBAT,
	END
}

enum COMBAT_STATE {
	ATK,
	DEF
}

var event
var event_info
var event_entity

var battle_state = BATTLE_STATES.TEXT
var combat_step = COMBAT_STATE.ATK

onready var battle_dialogue = get_node("battle_dialogue")

onready var battle_menu = get_node("battle_menu")
onready var menu_action = get_node("battle_menu/battle_action")
onready var menu_run = get_node("battle_menu/battle_run")
onready var menu_arr = [menu_action, menu_run]
var cursor_pos = 0

onready var player_stats = get_node("battle_menu/player_stats")
onready var enemy_stats = get_node("battle_menu/enemy_stats")

onready var text_timer = get_node("text_timer")

# Sets up logic around displaying the battle text
func _ready():
	event = get_parent()
	
	set_process(true)
	set_process_input(true)
	
func _process(delta):
	if battle_state == BATTLE_STATES.COMBAT:
		battle_dialogue.hide()
		battle_menu.show()
	elif battle_state == BATTLE_STATES.TEXT || battle_state == BATTLE_STATES.END:
		battle_dialogue.show()
		battle_menu.hide()
	
func _input(evt):
	if battle_state == BATTLE_STATES.TEXT && is_text_complete():
		if evt.is_action_pressed("ui_accept"):
			battle_state = BATTLE_STATES.COMBAT
			combat_step = combat_step % 2 == 0 if COMBAT_STATE.ATK else COMBAT_STATE.DEF
		
	if battle_state == BATTLE_STATES.COMBAT:
		if evt.is_action_pressed("move_left") || evt.is_action_pressed("move_right"):
			cursor_pos = (cursor_pos + 1) % menu_arr.size()
			select_menu_item(menu_arr[cursor_pos])
			
	# Accept pressed > select appropriate action
	
	# Action - Atk / Def phase
	
	# run 
		# Roll run die, display text
		#	globals.store("state", "GAME_IS_PLAYING")
		#	event.queue_free()
	
func setup():
	# Load all data about combat
	event_info = event.event_data.info
	
	# Get player data and store it
	player_stats = globals.get("player_data")
	
	# Get Enemy data and store it
	enemy_stats = event.event_data.entity
	enemy_stats['level'] = event_info.level
	
	# Set battle state to TEXT
	set_dialogue("A wild " + event_info.entity + " attacked!")
	
	# Prepare combat menu
	prepare_combat()
	
func _on_text_timer_timeout():
	if !is_text_complete():
		battle_dialogue.set_visible_characters(battle_dialogue.get_visible_characters() + 1)
	
func set_dialogue(text):
    battle_dialogue.set_bbcode(text)
    battle_dialogue.set_visible_characters(0)

func is_text_complete():
	return battle_dialogue.get_text().length() == battle_dialogue.get_visible_characters()
	
func prepare_combat():
	# Set combat menu values
	cursor_pos = 0
	print(get_menu_action_text())
	menu_action.set_bbcode(get_menu_action_text())
	
	select_menu_item(menu_action)
	
	# Set player stats
	
	# Set enemy stats
	
func get_menu_action_text():
	if (combat_step == COMBAT_STATE.ATK): 
		return "Attack" 
	else: 
		return "Defend"
	
func select_menu_item(menu_item):
	var text = menu_item.get_text()
	
	menu_item.clear()
	menu_item.append_bbcode("[color=#000000]" + text + "[/color]")
	menu_item.pop()
	
	for i in range(menu_arr.size()):
		if i != cursor_pos:
			var text = menu_arr[i].get_text()
			
			menu_arr[i].clear()
			menu_arr[i].append_bbcode("[color=#a5a5a5]" + text + "[/color]")
			menu_arr[i].pop()
	