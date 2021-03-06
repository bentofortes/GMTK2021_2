extends KinematicBody2D
class_name Player


onready var bullet = preload("res://Scenes/Player/Projectile.tscn")
onready var crosshair = $Crosshair
onready var lifeBar = $ProgressBar
onready var level = get_parent()
onready var camera = level.get_node("Camera2D")
onready var anta = camera.get_node("Anta")
onready var l_limit = level.get_node("Camera2D/L")
onready var leash :Line2D = level.get_node("Leash")


const gravity = 0.5
const terminal_v = 10
const acceleration = 0.4
const braking = 0.15
const max_speed = 12
const jump = -13

var mod = 0
var is_moving = false
var h_input = 0
var h_movement = 0
var v_movement = 10
var true_movement = Vector2(h_movement, v_movement)
var last_pos = position

var click_to_continue = false
var victory = false

const shot_cooldown = 0.2
var shot_cool_count = 0
const dmg_cooldown = 0.25
var dmg_cool_count = 0

var HP = 100


func _ready():
	lifeBar.value = HP
	leash.clear_points()
	leash.add_point(anta.global_position)
	leash.add_point(global_position)


func _physics_process(delta):
	_get_movement_input()
	_input_to_movement()
	
	move_and_slide(Vector2(h_movement, v_movement) * 1/delta, Vector2.UP)
	
	_detect_contact()
	_detect_squished()
	
	_get_true_movement(delta)
	_handle_cooldowns(delta)
	
	leash.clear_points()
	leash.add_point(anta.global_position + Vector2(440, 210))
	leash.add_point(global_position + Vector2(-28, 20))


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
	if click_to_continue:
		if !(event is InputEventMouseMotion):
			level.click_to_continue(victory)
	
	if (
		!Input.is_action_pressed("l_click")
	):
		return

	if (Input.is_action_pressed("l_click")):
		_shoot()


func _shoot():
	if (shot_cool_count > 0):
		return
	
	camera.scare_anta()
	
	var instance = bullet.instance()
	level.add_child(instance)
	instance.position = position
	instance.target = crosshair.global_position
	instance.speed += true_movement.x/4
	instance.custom_ready()
	
	shot_cool_count = shot_cooldown
	
	


func _handle_cooldowns(delta):
	shot_cool_count -= delta
	shot_cool_count = max(shot_cool_count, 0)
	
	dmg_cool_count -= delta
	dmg_cool_count = max(dmg_cool_count, 0)


func _detect_contact():
	var slide_count = get_slide_count()
	
	for i in range(slide_count):
		var col = get_slide_collision(i)
		
		if col.collider.get("is_zombi"):
			_damage()
			
		if col.collider.name == "Victory":
			_win()


func _detect_squished():
	if (l_limit.global_position.x > global_position.x):
		_die()


func handle_camera_push(speed):
	h_movement = speed


func _damage():
	if (dmg_cool_count > 0):
		return
		
	HP -= 20
	lifeBar.value = HP
	dmg_cool_count = dmg_cooldown
	
	if HP <= 0:
		_die()


func _die():
	level.lose()
	victory = false

#	var timer = Timer.new()
#	add_child(timer)
#	timer.wait_time = 1
#	timer.connect("timeout", self, "_on_timeout")
#	timer.start()


func _win():
	if victory:
		return
		
	level.win()
	victory = true

#	var timer = Timer.new()
#	add_child(timer)
#	timer.wait_time = 1
#	timer.connect("timeout", self, "_on_timeout")
#	timer.start()
#
#
#func _on_timeout():
#	click_to_continue = true
#	set_physics_process(false)



