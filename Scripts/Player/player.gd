extends KinematicBody2D


const gravity = 0.5
const acceleration = 0.25
const max_speed = 10
const jump = -8

var h_input = 0
var h_movement = 0

var v_input = 1
var v_movement = 1



func _physics_process(delta):
	_get_movement_input()
	_input_to_movement()
	
	move_and_slide(Vector2(h_movement, v_movement))



func _get_movement_input():
	h_input = 0
	
	if (Input.is_action_pressed("d")):
		h_input += 1 * max_speed
		
	if (Input.is_action_pressed("a")):
		h_input -= 1 * max_speed
		
	v_input = 1
	if self.is_on_floor():
		if (Input.is_action_pressed("w")) or (Input.is_action_pressed("space")):
			v_input = jump


func _input_to_movement():
	var direction = 0
	if (h_input - h_movement < 0):
		direction = -1
		
		h_movement += direction * acceleration
		h_movement = max(h_movement, h_input)
		
	elif (h_input - h_movement > 0):
		direction = 1
		
		h_movement += direction * acceleration
		h_movement = min(h_movement, h_input)
		
	if (v_input - v_movement > 0):
		v_movement += gravity
		v_movement = max(v_movement, 1)



