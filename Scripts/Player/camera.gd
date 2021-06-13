extends Camera2D


var main_menu = load("res://Scenes/Menu.tscn")

onready var level :Node2D = get_parent()
onready var player :Player = level.get_node("Player")
onready var l_wall :StaticBody2D = $L
onready var area :Area2D = $L/Area2D
onready var r_wall :StaticBody2D = $R
onready var stress_bar :ProgressBar = $Anta/ProgressBar
onready var timer :Timer = $Timer
onready var lose_label = $Lost
onready var win_label = $Won

const states = {
	"calm": 0,
	"pissed": 1,
	"miss_input": 2,
	"stopped": 3
}
var state = states.calm
var stress_level = 0
const max_stress = 120
var speed = 5


func _ready():
	set_physics_process(false)
	
	stress_bar.value = stress_level
	
	global_position.y = 296
	global_position.x = player.global_position.x + 200
	
	_force_calm_mode()


func _physics_process(delta):
	global_position.x  += speed
	_detect_player_push()
	
	stress_level -= 0.12
	stress_bar.value = stress_level
	
	_handle_stress_level()


func _detect_player_push():
	var bodies = area.get_overlapping_bodies()
	
	for b in bodies:
		if b.name == "Player":
			player.handle_camera_push(speed) 


func _force_calm_mode():
	set_physics_process(true)
	speed = 5
	state = states.calm


func _force_pissed_mode():
	set_physics_process(true)
	speed = 7
	state = states.pissed


func _force_miss_input_mode():
	set_physics_process(true)
	speed = 10
	state = states.miss_input


func _force_stopped_mode():
	set_physics_process(false)
	speed = 0
	state = states.stopped


func scare_anta():
	stress_level += 20
	stress_bar.value = stress_level
	
	if (stress_level > 120): stress_level = 120
	

func _handle_stress_level():
	_force_calm_mode()
	
	if (stress_level > 40):
		_force_pissed_mode()
		
	if (stress_level > 80):
		_force_miss_input_mode()
	
	
func lose():
#	var timer = Timer.new()
#	add_child(timer)
#	timer.wait_time = 3
#	timer.connect("timeout", self, "_timeout", [false])
#	timer.start()
	
	lose_label.visible = true
	
	
func win():
	_force_stopped_mode()
	
#	var timer = Timer.new()
#	add_child(timer)
#	timer.wait_time = 3
#	timer.connect("timeout", self, "_timeout", [true])
#	timer.start()
	
	win_label.visible = true
	

func click_to_continue(victory):
	if victory:
		if !Global.completed_levels.has(level.name):
			Global.completed_levels += [level.name]
		get_tree().change_scene_to(main_menu)
		
	else:
		get_tree().reload_current_scene()


