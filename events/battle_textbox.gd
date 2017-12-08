extends NinePatchRect

enum BATTLE_STATES {
	INTRO,
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

var battle_state = BATTLE_STATES.INTRO
var combat_step = COMBAT_STATE.ATK

onready var battle_dialogue = get_node("battle_dialogue")

onready var battle_menu = get_node("battle_menu")
onready var menu_action = get_node("battle_menu/battle_action")
onready var menu_run = get_node("battle_menu/battle_run")
onready var menu_arr = [menu_action, menu_run]
var cursor_pos = 0

onready var player_label = get_node("battle_menu/player_stats")
var player_stats
var player_stamina_max
var player_stamina

onready var enemy_label = get_node("battle_menu/enemy_stats")
var enemy_stats
var enemy_stamina_max
var enemy_stamina

var combat_won = false
var run_failed = false

# Sets up logic around displaying the battle text
func _ready():
	set_process_input(true)
	event = get_parent()

func _process(delta):
	if battle_state == BATTLE_STATES.COMBAT:
		battle_dialogue.hide()
		battle_menu.show()
	elif battle_state == BATTLE_STATES.INTRO || battle_state == BATTLE_STATES.TEXT || battle_state == BATTLE_STATES.END:
		battle_dialogue.show()
		battle_menu.hide()

func _input(evt):
	if battle_state == BATTLE_STATES.COMBAT:
		# Move cursor for selecting purposes
		if evt.is_action_pressed("move_left") || evt.is_action_pressed("move_right"):
			cursor_pos = (cursor_pos + 1) % menu_arr.size()
			select_menu_item(menu_arr[cursor_pos])

		# Accept pressed > select appropriate action
		if evt.is_action_pressed("ui_accept"):
			# Action - Atk / Def phase
			# Run - Roll run die, display text or run enemy action
			run_menu_item(menu_arr[cursor_pos])

	if (battle_state == BATTLE_STATES.INTRO || battle_state == BATTLE_STATES.TEXT) && is_text_complete():
		randomize()

		if evt.is_action_pressed("ui_accept"):
			if run_failed:
				run_failed()
			else:
				if (battle_state == BATTLE_STATES.TEXT):
					combat_step = (combat_step + 1) % 2

				if !is_combat_over():
					battle_state = BATTLE_STATES.COMBAT
					menu_action.set_bbcode(get_menu_action_text())
					select_menu_item(menu_action)
				else:
					battle_state = BATTLE_STATES.END
					end_combat()

	if battle_state == BATTLE_STATES.END && is_text_complete():
		if evt.is_action_pressed("ui_accept"):
			if (combat_won):
				# Clear event data, lets move on
				leave_event()
			else:
				get_tree().quit()
func setup():
	# Load all data about combat
	event_info = event.event_data.info

	# Get player data and store it
	player_stats = globals.get("player_data")
	player_stats['level'] = globals.get("level")

	# Get Enemy data and store it
	enemy_stats = event.event_data.entity
	enemy_stats['name'] = event_info.entity
	enemy_stats['level'] = event_info.level

	# Prepare combat menu
	prepare_combat()

	# Set battle state to TEXT
	set_dialogue("An enemy " + enemy_stats.name + " attacked!")

func end_combat():
	# Determine who just lost
	if enemy_stamina <= 0:
		# You won
		combat_won = true
		var xp_gain = abs(player_stats.level - enemy_stats.level) + (10 * enemy_stats.xp)
		var xp_req = globals.get("xp_req")

		globals.store("xp", globals.get("xp") + xp_gain)
		var message = "You gained " + String(xp_gain) + " exp!"

		if globals.get("xp") >= xp_req:
			var new_level = player_stats.level + 1
			globals.store("level", new_level)
			globals.store("xp_req", xp_req + (xp_req * 0.1))
			globals.store("xp", 0)
			message += " Level " + String(new_level) + " reached!"

		set_dialogue("*Victory fanfare plays* " + message)
	else:
		# You lost
		set_dialogue("You died...")

func get_menu_action_text():
	if (combat_step == COMBAT_STATE.ATK):
		return "Attack"
	else:
		return "Defend"

func leave_event():
	globals.store("event", {})
	globals.store("state", "GAME_IS_PLAYING")
	event.queue_free()

func run_menu_item(menu_item):
	# Run combat with player and enemy actions
	# Math time!
	if menu_item == menu_action:
		combat_phase()
	# Run "run" die roll: exit on success; enemy action on failure.
	elif menu_item == menu_run:
		run_phase()

func combat_phase():
	# Determine who is doing what
	var attacker
	var defender

	if (combat_step == COMBAT_STATE.ATK):
		attacker = player_stats
		defender = enemy_stats
	else:
		attacker = enemy_stats
		defender = player_stats

	var attack_result = roll_attack(attacker)
	var defense_result = roll_defense(defender)

	# Do Math
	var damage = abs(attack_result - defense_result)
	var attacker_label

	if (combat_step == COMBAT_STATE.ATK):
		attacker_label = "Hero"
		enemy_stamina -= damage
	else:
		attacker_label = "Enemy " + enemy_stats.name
		player_stamina -= damage

	# Update labels
	update_labels()

	var display_text
	if (damage == 0):
		display_text = "missed!"
	else:
		display_text = "hit for " + String(damage) + " damage!"

	# Run display text
	set_dialogue(attacker_label + " " + display_text)

func run_phase():
	var run_attempt = randi() % 100 + 1
	if run_attempt >= enemy_stats.run:
		combat_won = true
		battle_state = BATTLE_STATES.END
		set_dialogue("Managed to get away safely.")
	else:
		run_failed = true
		set_dialogue("Attempt to run failed...")

func run_failed():
	run_failed = false
	var attack_result = roll_attack(enemy_stats)
	var defense_result = 0

	# Do Math
	var damage = abs(attack_result - defense_result)
	var attacker_label

	attacker_label = "Enemy " + enemy_stats.name
	player_stamina -= damage

	# Update labels
	update_labels()

	var display_text
	if (damage == 0):
		display_text = "missed!"
	else:
		display_text = "hit for " + String(damage) + " damage!"

	# Run display text
	set_dialogue(attacker_label + " " + display_text)

func is_combat_over():
	return enemy_stamina <= 0 || player_stamina <= 0

func roll_attack(stats):
	var total_rolls = int(stats.base + (stats.level * stats.atk))
	var total_damage = 0

	for i in range(total_rolls):
		var roll = roll_d6()
		if (roll >= 3):
			total_damage += 1

		if (roll == 6):
			var roll = roll_d6()
			if (roll >= 3):
				total_damage += 1

	return total_damage

func roll_defense(stats):
	var total_rolls = int(stats.base + (stats.level * stats.def))
	var total_defense = 0

	for i in range(total_rolls):
		var roll = roll_d6()
		if (roll >= 3):
			total_defense += 1

	return total_defense + stats.armor

func roll_d6():
	return randi() % 5

func _on_text_timer_timeout():
	if !is_text_complete():
		battle_dialogue.set_visible_characters(battle_dialogue.get_visible_characters() + 1)

func set_dialogue(text):
	if (battle_state == BATTLE_STATES.COMBAT):
		battle_state = BATTLE_STATES.TEXT

	battle_dialogue.set_bbcode(text)
	battle_dialogue.set_visible_characters(0)

func is_text_complete():
	return battle_dialogue.get_text().length() == battle_dialogue.get_visible_characters()

func prepare_combat():
	# Set combat menu values
	cursor_pos = 0
	menu_action.set_bbcode(get_menu_action_text())
	select_menu_item(menu_action)

	# Set player stats
	player_stamina_max = player_stats.hp + (player_stats.hp * player_stats.base * player_stats.level)
	player_stamina = player_stamina_max

	# Set enemy stats
	enemy_stamina_max = enemy_stats.hp + (enemy_stats.hp * enemy_stats.base * enemy_stats.level)
	enemy_stamina = enemy_stamina_max

	update_labels()

func update_labels():
	player_label.set_bbcode("Lv." + String(player_stats.level) + " Hero " + String(player_stamina) + "/" + String(player_stamina_max) + "hp")
	enemy_label.set_bbcode( "Lv." + String(enemy_stats.level) + " " + enemy_stats.name + " " + String(enemy_stamina) + "/" + String(enemy_stamina_max) + "hp")

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
