extends CharacterBody2D
class_name Fox

var dash_duration = 10

var jump_squat: int = 3
var landing_frames: int = 0
var lag_frames: int = 0
var fastfall: bool = false

@onready var GroundL = get_node("Raycasts/GroundL")
@onready var GroundR = get_node("Raycasts/GroundR")
@onready var Ledge_Grab_F = get_node("Raycasts/Ledge_Grab_F")
@onready var Ledge_Grab_B = get_node("Raycasts/Ledge_Grab_B")
@onready var anim = $Sprite/AnimationPlayer

var RUNSPEED = 340
var DASHSPEED = 390
var WALKSPEED = 200
var GRAVITY = 1800
var JUMPFORCE = 500
var MAX_JUMPFORCE = 800
var DOUBLEJUMPFORCE = 1000
var MAXAIRSPEED = 300
var AIR_ACCEL = 25 
var FALLSPEED = 60
var FALLINGSPEED = 900
var MAXFALlSPEED = 900
var TRACTION = 40 
var ROLL_DISTANCE = 350
var air_dodge_speed = 500
var UP_B_LAUNCHSPEED = 700

var frame = 0
func updateframes(delta):
	frame += 1

func turn(direction):
	var dir = 0
	if direction:
		dir = -1
	else:
		dir = 1
	$Sprite.set_flip_h(direction)
	Ledge_Grab_F.set_target_position(Vector2(dir*abs(Ledge_Grab_F.get_target_position().x),Ledge_Grab_F.get_target_position().y))
	Ledge_Grab_F.position.x = dir * abs(Ledge_Grab_F.position.x)
	Ledge_Grab_B.position.x = dir * abs(Ledge_Grab_B.position.x)
	Ledge_Grab_B.set_target_position(Vector2(-dir*abs(Ledge_Grab_F.get_target_position().x),Ledge_Grab_F.get_target_position().y))
func direction():
	if Ledge_Grab_F.get_target_position().x > 0:
		return 1
	else:
		return -1

func frames():
	frame = 0

func play_animation(animation_name):
	anim.play(animation_name)

func _ready():
	pass

func _physics_process(delta):
	$Frames.text = str(frame)
