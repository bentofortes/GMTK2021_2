extends KinematicBody2D
class_name Player


onready var bullet = preload("res://Scenes/Player/Projectile.tscn")
onready var crosshair = $Crosshair
onready var level = get_parent()


const gravity = 0.5
const terminal_v = 10
const acceleration = 0.25
const braking = 0.15
const max_speed = 10
const jump = -12

var mod = 0
var is_moving = false
var h_input = 0
var h_movement = 0
var v_movement = 10
var true_movement = Vector2(h_movement, v_movement)
var last_pos = position

var shot_cooldown = 0.3
var cool_count = 0


func _physics_process(delta):
	_get_movement_input()
	_input_to_movement()
	
	move_and_slide(Vector2(h_movement, v_movement) * 1/delta, Vector2.UP)
	_get_true_movement(delta)
	
	_handle_cooldowns(delta)


func _get_movement_input():
	h_input = 0
	
	if (Input.is_action_pressed("d")):
		h_input += 1 * max_speed
		is_moving = true
		
	if (Input.is_action_pressed("a")):
		h_input -= 1 * max_speed
		is_moving = true
		
	if is_on_floor():
		if (Input.is_action_pressed("w")) or (Input.is_action_pressed("space")):
			v_movement = jump


func _input_to_movement():
	var direction = 0
	
	mod = 0
	if (abs(h_input - h_movement)  > max_speed) and is_on_floor():
		mod = braking
		
	if (h_input - h_movement < 0):
		direction = -1

		h_movement += direction * (acceleration + mod)
		h_movement = max(h_movement, h_input)
		
	elif (h_input - h_movement > 0):
		direction = 1
		
		h_movement += direction * (acceleration + mod)
		h_movement = min(h_movement, h_input)
		
	v_movement += gravity
	v_movement = min(v_movement, terminal_v)


func _get_true_movement(delta):
	true_movement = (position - last_pos)
	
	if (abs(true_movement.x) <= 0.1):
		h_movement = 0
		
	if (abs(true_movement.y) <= 0.1):
		v_movement = gravity

	last_pos = position


func _unhandled_input(event):
	if (
		!Input.is_action_pressed("l_click")
	):
		return

	if (Input.is_action_pressed("l_click")):
		_shoot()


func _shoot():
	if (cool_count > 0):
		return
		
	var instance = bullet.instance()
	level.add_child(instance)
	instance.position = position
	instance.target = crosshair.global_position
	instance.speed += true_movement.x/4
	instance.custom_ready()
	
	cool_count = shot_cooldown


func _handle_cooldowns(delta):
	cool_count -= delta
	cool_count = max(cool_count, 0)


