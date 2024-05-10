extends Character
class_name Fox

func create_hitbox(width, height, damage, angle, base_kb, kb_scaling, duration, type, points, angle_flipper, hitlag = 1):
	var hitbox_instance = hitbox.instantiate()
	self.add_child(hitbox_instance)
	if direction() == 1:
		hitbox_instance.set_parameters(width, height, damage, angle, base_kb, kb_scaling, duration, type, points, angle_flipper, hitlag)
	else:
		var flip_x_points = Vector2(-points.x, points.y)
		hitbox_instance.set_parameters(width, height, damage, -angle + 180, base_kb, kb_scaling, duration, type, flip_x_points, angle_flipper, hitlag)
	return hitbox_instance

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

func reset_Jumps():
	air_jumps = MAX_AIR_JUMPS

func reset_ledge():
	last_ledge = null

func _ready():
	pass

func _physics_process(delta):
	$Frames.text = str(frame)
	selfState = states

func DOWN_TILT():
	if frame == 5:
		call_deferred("create_hitbox", 40, 20, 8, 90, 3, 120, 3, 'normal', Vector2(64,32), 0, 1)
	if frame >= 10:
		return true

func UP_TILT():
	if frame == 5:
		call_deferred("create_hitbox", 48, 68, 8, 110, 20, 110, 2, 'normal', Vector2(-22, -15),0, 1)
	if frame >= 12:
		return true

func FORWARD_TILT():
	if frame == 3:
		call_deferred("create_hitbox",52, 20, 6, 120, 40, 80, 3, 'normal', Vector2(22, 8),0, 1)
	if frame >= 8:
		return true

func NAIR():
	if frame == 1:
		call_deferred("create_hitbox", 56, 56, 12, 361, 0, 100, 3, 'normal', Vector2(0,0),0, .4)
	if frame > 1:
		if connected == true:
			if frame == 36:
				connected = false
				return true
		else:
			if frame == 5:
				call_deferred("create_hitbox",46, 56, 9, 361, 0, 100, 10, 'normal', Vector2(0,0),0, .1)
			if frame == 36:
				return true

func UAIR():
	if frame == 2:
		call_deferred("create_hitbox", 32, 36, 5, 90, 130, 0, 2, 'normal', Vector2(0, -45), 0, 1)
	if frame == 6:
		call_deferred("create_hitbox",56, 46, 10, 90, 20, 108, 3, 'normal', Vector2(0, -48),0, 2)
	if frame == 15:
		return true

func BAIR():
	if frame == 2:
		call_deferred("create_hitbox", 52, 55, 15, 45, 1, 100, 5, 'normal', Vector2(-47, 7), 6, 1)
	if frame > 1:
		if connected == true:
			if frame == 18:
				connected = false
				return true
		else:
			if frame == 7:
				call_deferred("create_hitbox",52, 55, 5, 45, 3, 140, 10, 'normal', Vector2(-47, 7), 6, 1)
			if frame == 18:
				return true

func FAIR():
	if frame == 2:
		call_deferred("create_hitbox", 35, 47, 3, 76, 10, 150, 3, 'normal', Vector2(60, -7),0, 1)
	if frame == 11:
		call_deferred("create_hitbox", 35, 47, 3, 76, 10, 150, 3, 'normal', Vector2(60, -7),0, 1)
	if frame == 18:
		return true

func DAIR():
	if frame == 2:
		call_deferred("create_hitbox", 36, 58, 2, 290, 140, 0, 2, 'normal', Vector2(28, 17), 0, 1)
	if frame == 3:
		call_deferred("create_hitbox", 36, 58, 2, 290, 140, 0, 2, 'normal', Vector2(28, 17), 0, 1)
	if frame == 5:
		call_deferred("create_hitbox", 36, 58, 2, 290, 140, 0, 2, 'normal', Vector2(28, 17), 0, 1)
	if frame == 7:
		call_deferred("create_hitbox", 36, 58, 2, 290, 140, 0, 2, 'normal', Vector2(28, 17), 0, 1)
	if frame == 9:
		call_deferred("create_hitbox", 36, 58, 2, 290, 140, 0, 2, 'normal', Vector2(28, 17), 0, 1)
	if frame == 11:
		call_deferred("create_hitbox", 36, 58, 2, 290, 140, 0, 2, 'normal', Vector2(28, 17), 0, 1)
	if frame == 14:
		call_deferred("create_hitbox", 36, 58, 2, 290, 140, 0, 2, 'normal', Vector2(28, 17), 0, 1)
	if frame == 17:
		return true
	
