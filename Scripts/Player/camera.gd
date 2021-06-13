extends Camera2D


onready var level :Node2D = get_parent()
onready var player :Player = level.get_node("Player")
onready var l_wall :StaticBody2D = $L
onready var area :Area2D = $L/Area2D
onready var r_wall :StaticBody2D = $R

onready var stress_bar :ProgressBar = $Anta/ProgressBar

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
	
	stress_level -= 0.07
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


func _stopped_mode():
	set_physics_process(false)
	speed = 0
	state = states.stopped


func scare_anta():
	print("scare anta")
	stress_level += 15
	stress_level = min(stress_level, max_stress)
	stress_bar.value = stress_level
	

func _handle_stress_level():
	_force_calm_mode()
	
	if (stress_level > 40):
		_force_pissed_mode()
		
	if (stress_level > 80):
		_force_miss_input_mode()
	
	






