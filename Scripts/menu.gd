extends Control


var tutorial = preload("res://Scenes/Levels/TestLevel.tscn")

onready var tutorial_button = $Tutorial
onready var level1 = $Level1
onready var level2 = $Level2
onready var level3 = $Level3

func _ready():
	tutorial_button.connect("pressed", self, "_goto_tutorial")
	
	if Global.completed_levels.has("Level1"):
		level2.disabled = false
		
	if Global.completed_levels.has("Level2"):
		level3.disabled = false


func _goto_tutorial():
	get_tree().change_scene_to(tutorial)
