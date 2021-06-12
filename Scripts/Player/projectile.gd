extends Area2D


var target = Vector2()
var direction = Vector2()
var speed = 24

func custom_ready():
	look_at(target)
	direction = (target - global_position).normalized()

func _physics_process(delta):
	global_position += direction * speed
