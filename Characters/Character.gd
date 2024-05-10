extends CharacterBody2D
class_name Character

var states = {}
@export var id: int

@export var percentage = 0
@export var stocks = 3
@export var weight = 100

var hdecay
var vdecay
var knockback
var hitstun
var in_air
var connected:bool

#Jump
var dash_duration = 10
var jump_squat: int = 3
var landing_frames: int = 0
var lag_frames: int = 0
var fastfall: bool = false
var air_jumps: int = 0

#Ledges
var last_ledge: Node = null
var regrab: int = 30
var catch: bool = false

#Wavedash
var perfect_wavedash_modifier = .5

#Hitbox
@export var hitbox: PackedScene
var selfState

@export var MAX_AIR_JUMPS = 1
@export var RUN_SPEED = 340
@export var DASH_SPEED = 390
@export var WALK_SPEED = 200
@export var GRAVITY = 1800
@export var JUMP_FORCE = 500
@export var LEDGE_JUMP_FORCE = 500
@export var LEDGE_JUMP_DIRECTION_FORCE = 220
@export var MAX_JUMP_FORCE = 800
@export var DOUBLE_JUMP_FORCE = 1000
@export var MAX_AIR_SPEED = 300
@export var AIR_ACCEL = 25 
@export var FALL_SPEED = 60
@export var FALLING_SPEED = 900
@export var MAX_FALL_SPEED = 900
@export var TRACTION = 40 
@export var ROLL_DISTANCE = 350
@export var AIR_DODGE_SPEED = 500
@export var UP_B_LAUNCHSPEED = 700

# Required components for a character
@export var GroundL: RayCast2D
@export var GroundR: RayCast2D
@export var Ledge_Grab_F: RayCast2D
@export var Ledge_Grab_B: RayCast2D
@export var anim: AnimationPlayer

var frame = 0
func updateframes(delta):
	frame += 1
