extends Camera2D


onready var player :Player = get_node("../Player")


func _ready():
	global_position.y = 296


