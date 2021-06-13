extends KinematicBody2D


onready var visibility = $VisibilityNotifier2D
onready var area = $Area2D
var is_visible = false
var is_zombi = true


func _ready():
	pass


func _physics_process(delta):
	_detect_visibility()
	_detect_hit()

	_move()

func _die():
	self.queue_free()


func _detect_hit():
	if !is_visible:
		return
		
	var areas = area.get_overlapping_areas()
	
	for a in areas:
		if a.name == "Projectile":
			a.explode()
			_die()

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


func _move():
	if !is_visible:
		return
		
	global_position.x -= 3
