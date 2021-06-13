extends Node2D


onready var camera :Camera2D = $Camera2D


func win():
	print("win")
	camera.win()

func lose():
	print("lsoe")
	camera.lose()


func click_to_continue(victory):
	camera.click_to_continue(victory)


