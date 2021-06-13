extends Node2D


onready var camera :Camera2D = $Camera2D
onready var player :Player = $Player

var victory = false

func win():
	camera.win()

	victory = true

	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1
	timer.connect("timeout", self, "_on_timeout")
	timer.start()

func lose():
	camera.lose()

	victory = false

	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1
	timer.connect("timeout", self, "_on_timeout")
	timer.start()

func click_to_continue(victory):
	camera.click_to_continue(victory)


func _on_timeout():
	player.click_to_continue = true
	player.set_physics_process(false)
