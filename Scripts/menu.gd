extends Control


var tutorial = preload("res://Scenes/Levels/TestLevel.tscn")
var level1 = preload("res://Scenes/Levels/Level1.tscn")
var level2 = preload("res://Scenes/Levels/Level2.tscn")

onready var tutorial_button = $Tutorial
onready var level1_button = $Level1
onready var level2_button = $Level2
#onready var level3_button = $Level3

func _ready():
	tutorial_button.connect("pressed", self, "_goto_tutorial")
	level1_button.connect("pressed", self, "_goto_level1")
	level2_button.connect("pressed", self, "_goto_level2")
	
	if Global.completed_levels.has("TestLevel"):
		level1_button.disabled = false
	
	if Global.completed_levels.has("Level1"):
		level2_button.disabled = false
		
#	if Global.completed_levels.has("Level2"):
#		level3_button.disabled = false


func _goto_tutorial():
	get_tree().change_scene_to(tutorial)
	
func _goto_level1():
	get_tree().change_scene_to(level1)
	
func _goto_level2():
	get_tree().change_scene_to(level2)
