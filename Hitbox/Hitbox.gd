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
	connect("body_entered", self.handle_hitbox_collision, CONNECT_DEFERRED)
	set_physics_process(true)

func update_extents():
	hitbox.shape.extents = Vector2(width, height)

func _ready():
	hitbox.shape = RectangleShape2D.new()
	set_physics_process(false)

func _physics_process(delta):
	if framez < duration:
		framez += floor(delta * 60)
	elif framez == duration:
		#Engine.time_scale = 1
		queue_free()
		return
	if get_parent().selfState != parentstate:
		Engine.time_scale = 1
		queue_free()
		return 
		
func handle_hitbox_collision(body: Node2D):
	if body not in player_list:
		player_list.append(body)
		var charstate
		charstate = body.get_node("StateMachine")
		weight = body.weight
		body.percentage += damage
		knockbackval = knockback(body.percentage,damage,weight,kb_scaling,base_kb,1)
		s_angle(body)
		charstate.state = charstate.states.HITFREEZE
		charstate.hitfreeze(
			hitlag(damage, hitlag_modifier),
			angle_flippersv2(Vector2(body.velocity.x, body.velocity.y), body.global_position)
		)
		#charstate.hitfreeze(hitlag(damage, hitlag_modifier),angle_flippers(Vector2(body.velocity.y)))#, body.global_position))

		body.knockback = knockbackval
		body.hitstun = getHitstun(knockbackval/0.3)
		get_parent().connected = true
		body.frames()

		Globals.hitstun(hitlag(damage, hitlag_modifier), hitlag(damage,hitlag_modifier)/60)
		get_parent().hit_pause_dir = duration - framez
		get_parent().temp_pos = get_parent().position
		get_parent().temp_vel = get_parent().velocity

func getHitstun(knockback):
	return floor(knockback * 0.4);

func hitlag(dmg: float, lag: float) -> float:
	damage = dmg
	hitlag_modifier = lag
	return floor((((floor(dmg) * 0.65) + 6) * lag))

@export var percentage = 0
@export var weight = 100
@export var base_knockback = 40
@export var ratio = 1

func knockback(p,d,w,ks,bk,r):
	percentage = p
	damage = d
	weight = w
	kb_scaling = ks
	base_kb = bk
	ratio = r
	return ((((((((percentage/10) + (percentage*damage/20)) * (200/ (weight+100)) * 1.4) + 18) * (kb_scaling)) + base_kb) * 1)) * .004

func s_angle(body):
		if angle == 361:
			if knockbackval > 28:
				if body.in_air == true:
					angle = 40
				else:
					angle = 38
			else:
				if body.in_air == true:
					angle = 40
				else:
					angle = 25
		elif angle == -181:
			if knockbackval > 28:
				if body.in_air == true:
					angle = (-40)+180
				else:
					angle = (-38)+180
			else:
				if body.in_air == true:
					angle = (-40)+180
				else:
					angle = (-38)+180

const angleConversion = PI / 180

func getHorizontalDecay(angle):
	var decay = 0.051 * cos(angle * angleConversion)
	decay = round(decay * 100000) / 100000
	decay = decay * 1000
	return decay

func getVerticalDecay(angle):
	var decay = 0.051 * sin(angle * angleConversion)
	decay = round(decay * 100000) / 100000
	decay = decay * 1000
	return abs(decay)

func getHorizontalVelocity(knockback, angle):
	var initialVelocity = knockback * 30;
	var horizontalAngle = cos(angle * angleConversion);
	var horizontalVelocity = initialVelocity * horizontalAngle;
	horizontalVelocity = round(horizontalVelocity * 100000) / 100000;
	return horizontalVelocity;

func getVerticalVelocity(knockback, angle):
	var initialVelocity = knockback * 30;
	var verticalAngle = sin(angle * angleConversion);
	var verticalVelocity = initialVelocity * verticalAngle;
	verticalVelocity = round(verticalVelocity * 100000) / 100000;
	return verticalVelocity

func angle_flippers(body: Node2D):
	var xangle
	if get_parent().direction() == 1:
		xangle = (-(((body.global_position.angle_to_point(get_parent().global_position))*180)/PI))
	else:
		xangle = (((body.global_position.angle_to_point(get_parent().global_position))*180)/PI)

	match angle_flipper:
		0:
			body.velocity.x = (getHorizontalVelocity (knockbackval, -angle))
			body.velocity.y = (getVerticalVelocity (knockbackval, -angle))
			body.hdecay = (getHorizontalDecay(-angle))
			body.vdecay = (getVerticalDecay(angle))

		1:
			if get_parent().direction() == -1:
				xangle = -(((self.global_position.angle_to_point(body.get_parent().global_position))*180)/PI)
			else:
				xangle = (((self.global_position.angle_to_point(body.get_parent().global_position))*180)/PI)
			body.velocity.x = ((getHorizontalVelocity (knockbackval, xangle + 180)))
			body.velocity.y = ((getVerticalVelocity (knockbackval, -xangle)))
			body.hdecay = (getHorizontalDecay(angle+180))
			body.vdecay = (getVerticalDecay(xangle))

		2:
			if get_parent().direction() == -1:
				xangle = -(((body.get_parent().global_position.angle_to_point(self.global_position))* 180)/PI)
			else:
				xangle = (((body.get_parent().global_position.angle_to_point(self.global_position))*180)/PI)
			body.velocity.x = ((getHorizontalVelocity(knockbackval, -xangle+180)))
			body.velocity.y = ((getVerticalVelocity(knockbackval, -xangle)))
			body.hdecay = (getHorizontalDecay(xangle+180))
			body.vdecay = (getVerticalDecay(xangle))

		3:
			if get_parent().direction() == -1:
				xangle = (-(((body.get_parent().global_position.angle_to_point(self.global_position))* 180)/PI))+180
			else:
				xangle = (((body.get_parent().global_position.angle_to_point(self.global_position))*180)/PI)
			body.velocity.x = (getHorizontalVelocity (knockbackval, xangle))
			body.velocity.y = (getVerticalVelocity(knockbackval, -angle))
			body.hdecay = (getHorizontalDecay(xangle))
			body.vdecay = (getVerticalDecay(angle))

		4:
			if get_parent().direction() == -1:
				xangle = -(((body.get_parent().global_position.angle_to_point(self.global_position))* 180)/PI)+180
			else:
				xangle = (((body.get_parent().global_position.angle_to_point(self.global_position))*180)/PI)
			body.velocity.x = (getHorizontalVelocity(knockbackval, -xangle * 180))
			body.velocity.y = (getVerticalVelocity(knockbackval, -angle))
			body.hdecay = (getHorizontalDecay(angle))
			body.vdecay = (getVerticalDecay(angle))

		5:
			body.velocity.x = (getHorizontalVelocity(knockbackval, -xangle + 180))
			body.velocity.y = (getVerticalVelocity(knockbackval, -angle))
			body.hdecay = (getHorizontalDecay(angle+180))
			body.vdecay = (getVerticalDecay(angle))

		6:
			body.velocity.x = (getHorizontalVelocity((knockbackval), xangle))
			body.velocity.y = (getVerticalVelocity(knockbackval, -angle))
			body.hdecay = (getHorizontalDecay(xangle))
			body.vdecay = (getVerticalDecay(angle))

		7:
			body.velocity.x = (getHorizontalVelocity(knockbackval, -xangle * 180))
			body.velocity.y = (getVerticalVelocity(knockbackval, -angle))
			body.hdecay = (getHorizontalDecay(angle))
			body.vdecay = (getVerticalDecay(angle))

func angle_flippersv2(body_vel: Vector2, body_position: Vector2, hdecay = 0, vdecay = 0):
	var xangle
	if get_parent().direction() == -1:
		xangle = (-(((body_position.angle_to_point(get_parent().global_position))*180)/PI))
	else:
		xangle = (((body_position.angle_to_point(get_parent().global_position))*180)/PI)

	match angle_flipper:
		0:
			body_vel.x = (getHorizontalVelocity (knockbackval, -angle))
			body_vel.y = (getVerticalVelocity (knockbackval, -angle))
			hdecay = (getHorizontalDecay(-angle))
			vdecay = (getVerticalDecay(angle))
			return [body_vel.x, body_vel.y, hdecay, vdecay]

		1:
			if get_parent().direction() == -1:
				xangle = -(((self.global_position.angle_to_point(get_parent().global_position))*180)/PI)
			else:
				xangle = (((self.global_position.angle_to_point(get_parent().global_position))*180)/PI)
			body_vel.x = ((getHorizontalVelocity (knockbackval, xangle + 180)))
			body_vel.y = ((getVerticalVelocity (knockbackval, -xangle)))
			hdecay = (getHorizontalDecay(angle+180))
			vdecay = (getVerticalDecay(xangle))
			return [body_vel.x, body_vel.y, hdecay, vdecay]

		2:
			if get_parent().direction() == -1:
				xangle = -(((get_parent().global_position.angle_to_point(self.global_position))* 180)/PI)
			else:
				xangle = (((get_parent().global_position.angle_to_point(self.global_position))*180)/PI)
			body_vel.x = ((getHorizontalVelocity(knockbackval, -xangle+180)))
			body_vel.y = ((getVerticalVelocity(knockbackval, -xangle)))
			hdecay = (getHorizontalDecay(xangle+180))
			vdecay = (getVerticalDecay(xangle))
			return [body_vel.x, body_vel.y, hdecay, vdecay]

		3:
			if get_parent().direction() == -1:
				xangle = (-(((get_parent().global_position.angle_to_point(self.global_position))* 180)/PI))+180
			else:
				xangle = (((get_parent().global_position.angle_to_point(self.global_position))*180)/PI)
			body_vel.x = (getHorizontalVelocity (knockbackval, xangle))
			body_vel.y = (getVerticalVelocity(knockbackval, -angle))
			hdecay = (getHorizontalDecay(xangle))
			vdecay = (getVerticalDecay(angle))
			return [body_vel.x, body_vel.y, hdecay, vdecay]

		4:
			if get_parent().direction() == -1:
				xangle = -(((get_parent().global_position.angle_to_point(self.global_position))* 180)/PI)+180
			else:
				xangle = (((get_parent().global_position.angle_to_point(self.global_position))*180)/PI)
			body_vel.x = (getHorizontalVelocity(knockbackval, -xangle * 180))
			body_vel.y = (getVerticalVelocity(knockbackval, -angle))
			hdecay = (getHorizontalDecay(angle))
			vdecay = (getVerticalDecay(angle))
			return [body_vel.x, body_vel.y, hdecay, vdecay]

		5:
			body_vel.x = (getHorizontalVelocity(knockbackval, -xangle + 180))
			body_vel.y = (getVerticalVelocity(knockbackval, -angle))
			hdecay = (getHorizontalDecay(angle+180))
			vdecay = (getVerticalDecay(angle))
			return [body_vel.x, body_vel.y, hdecay, vdecay]

		6:
			body_vel.x = (getHorizontalVelocity((knockbackval), xangle))
			body_vel.y = (getVerticalVelocity(knockbackval, -angle))
			hdecay = (getHorizontalDecay(xangle))
			vdecay = (getVerticalDecay(angle))
			return [body_vel.x, body_vel.y, hdecay, vdecay]

		7:
			body_vel.x = (getHorizontalVelocity(knockbackval, -xangle * 180))
			body_vel.y = (getVerticalVelocity(knockbackval, -angle))
			hdecay = (getHorizontalDecay(angle))
			vdecay = (getVerticalDecay(angle))
			return [body_vel.x, body_vel.y, hdecay, vdecay]
