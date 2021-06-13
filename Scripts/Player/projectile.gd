extends KinematicBody2D


onready var visibility = $VisibilityNotifier2D
var is_visible = false
var can_explode = false

var target = Vector2()
var direction = Vector2()
var speed = 24


func _redy():
	set_physics_process(false)


func custom_ready():
	look_at(target)
	direction = (target - global_position).normalized()
	set_physics_process(true)


func _physics_process(delta):
#	global_position += direction * speed
	var col = move_and_collide(direction * speed)
	if col:
		if col.collider.get("is_zombi"):
			col.collider.die()
			_explode()
	
	_detect_visibility()
	_exit_screen()


func _detect_visibility():
	if visibility.is_on_screen():
		can_explode = true


func _exit_screen():
	if !can_explode:
		return
		
	if !visibility.is_on_screen():
		self.queue_free()


func _explode():
	queue_free()

