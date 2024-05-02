extends Area2D

var parent = get_parent()
@export var width = 300
@export var height = 400
@export var damage = 50
@export var angle = 90
@export var base_kb = 100
@export var kb_scaling = 2
@export var duration = 1500
@export var hitlag_modifier = 1
@export var type = 'normal'
@export var angle_flipper = 0
@onready var hitbox = get_node("Hitbox_Shape")
@onready var parentstate = get_parent().selfState
var knockbackval
var framez = 0.0
var player_list = []

func set_parameters(w, h, d, a, b_kb, kb_s, dur, t, p, hit, af, parent = get_parent()):
	self.position = Vector2(0, 0)
	player_list.append(parent)
	player_list.append(self)
	width = w
	height = h
	damage = d
	angle = a
	base_kb = b_kb
	kb_scaling = kb_s
	duration = dur
	type = t
	self.position = p
	hitlag_modifier = hit
	angle_flipper = af
	update_extents()
	connect("area_entered", self.handle_hitbox_collision, CONNECT_DEFERRED)
	set_physics_process(true)

func update_extents():
	hitbox.shape.extents = Vector2(width, height)

func _ready():
	hitbox.shape = RectangleShape2D.new()
	set_physics_process(false)

func _physics_process(delta):
	if framez < duration:
		framez += 1
	elif framez == duration:
		Engine.time_scale = 1
		queue_free()
		return
	if get_parent().selfState != parentstate:
		Engine.time_scale = 1
		queue_free()
		return 
		
func handle_hitbox_collision(body: Node):
	print("get punched ", body)
