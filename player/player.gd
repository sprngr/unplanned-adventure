extends KinematicBody2D

const MAX_SPEED = 128

var grid
var type
var speed = 0
var direction = Vector2()
var velocity = Vector2()

var is_moving = false
var target_pos = Vector2()
var target_direction = Vector2()

signal move

func _ready():
	set_physics_process(true)
	grid = get_parent()
	type = grid.PLAYER

func _physics_process(delta):
	direction = Vector2()

	if globals.get("state") != "GAME_IS_PLAYING":
		is_moving = false
		speed = 0
		velocity = Vector2()
	else:
		if Input.is_action_pressed("move_up"):
			direction.y = -1
		elif Input.is_action_pressed("move_down"):
			direction.y = 1
		elif Input.is_action_pressed("move_right"):
			direction.x = 1
		elif Input.is_action_pressed("move_left"):
			direction.x = -1

		globals.store("player_direction", direction)

		if not is_moving and globals.get("player_direction") != Vector2():
			target_direction = globals.get("player_direction")
			if grid.is_cell_passable(get_position(), target_direction):
				target_pos = grid.update_child_pos(self)
				is_moving = true
		elif is_moving:
			speed = MAX_SPEED
			velocity = speed * target_direction.normalized() * delta

			var pos = get_position()
			var distance_to_target = Vector2(abs(target_pos.x - pos.x), abs(target_pos.y - pos.y))

			if abs(velocity.x) > distance_to_target.x:
				velocity.x = distance_to_target.x * target_direction.x
				is_moving = false

			if abs(velocity.y) > distance_to_target.y:
				velocity.y = distance_to_target.y * target_direction.y
				is_moving = false

			move_and_collide(velocity)
			grid.update_camera()
