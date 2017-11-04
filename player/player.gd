extends KinematicBody2D

const MAX_SPEED = 64

var grid
var type
var speed = 0
var direction = Vector2()
var velocity = Vector2()

var is_moving = false
var target_pos = Vector2()
var target_direction = Vector2()

func _ready():
	grid = get_parent()
	type = grid.PLAYER
	set_fixed_process(true)

func _fixed_process(delta):
	direction = Vector2()

	if Input.is_action_pressed("move_up"):
		direction.y = -1
	elif Input.is_action_pressed("move_down"):
		direction.y = 1
	if Input.is_action_pressed("move_right"):
		direction.x = 1
	elif Input.is_action_pressed("move_left"):
		direction.x = -1

	if not is_moving and direction != Vector2():
		target_direction = direction
		if grid.is_cell_vacant(get_pos(), target_direction):
			target_pos = grid.update_child_pos(self)
			is_moving = true
	elif is_moving:
		speed = MAX_SPEED
		velocity = speed * target_direction.normalized() * delta

		var pos = get_pos()
		var distance_to_target = Vector2(abs(target_pos.x - pos.x), abs(target_pos.y - pos.y))

		if abs(velocity.x) > distance_to_target.x:
			velocity.x = distance_to_target.x * target_direction.x
			is_moving = false

		if abs(velocity.y) > distance_to_target.y:
			velocity.y = distance_to_target.y * target_direction.y
			is_moving = false

		move(velocity)
