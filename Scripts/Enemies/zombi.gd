extends KinematicBody2D


onready var visibility = $VisibilityNotifier2D
onready var area = $Area2D
var is_visible = false
var is_zombi = true

const gravity = 0.5
const terminal_v = 10
var fall_speed = gravity


func _ready():
	pass


func _physics_process(delta):
	_detect_visibility()
#	_detect_hit()

	_move(delta)

func die():
	self.queue_free()


#func _detect_hit():
#	if !is_visible:
#		return
#
#	var areas = area.get_overlapping_areas()
#
#	for a in areas:
#		if a.name == "Projectile":
#			a.explode()
#			_die()

#	var bodies = area.get_overlapping_bodies()
#
#	for b in bodies:
#		if b.name == "Player":
#			b.damage()


func _detect_visibility():
	if visibility.is_on_screen():
		is_visible = true
		
	else:
		is_visible = false


func _move(delta):
	if !is_visible:
		return
		
	if !is_on_floor():
		fall_speed += gravity
		fall_speed = min(fall_speed, terminal_v)
		
	else:
		fall_speed = gravity
		
#	global_position.x -= 3
#	global_position.y += 2
	move_and_slide(Vector2(-3, fall_speed) * 1/delta)
	
	
