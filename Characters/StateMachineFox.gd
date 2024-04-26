extends StateMachine
@export var id = 1

func _ready():
	add_state('STAND')
	add_state('JUMP_SQUAT')
	add_state('SHORT_HOP')
	add_state('FULL_HOP')
	add_state('DASH')
	add_state('RUN')
	add_state('MOONWALK')
	add_state('WALK')
	add_state('TURN')
	add_state('CROUCH')
	add_state('AIR')
	add_state('LANDING')
	add_state('LEDGE_CATCH')
	add_state('LEDGE_HOLD')
	add_state('LEDGE_CLIMB')
	add_state('LEDGE_JUMP')
	add_state('LEDGE_ROLL')
	call_deferred("set_state", states.STAND)

func state_logic(delta):
	parent.updateframes(delta)
	parent._physics_process(delta)
	if parent.regrab > 0:
		parent.regrab -= 1

func get_transition(delta):
	#parent.move_and_slide_with_snap(parent.velocity*2,Vector2.ZERO,Vector2.UP)

	if Landing() == true:
		parent.frames()
		return states.LANDING

	if Falling() == true:
		return states.AIR

	if Ledge() == true:
		parent.frames()
		return states.LEDGE_CATCH
	else:
		parent.reset_ledge()

	match state:
		
		states.STAND:
			parent.reset_Jumps()
			if Input.is_action_just_pressed("jump_%s" % id):
				parent.frames()
				return states.JUMP_SQUAT

			if Input.is_action_pressed("down_%s" % id):
				parent.frames()
				return states.CROUCH

			if Input.get_action_strength("right_%s" % id) == 1:
				parent.velocity.x = parent.RUNSPEED
				parent.frames()
				parent.turn(false)
				return states.DASH

			if Input.get_action_strength("left_%s" % id) == 1:
				parent.velocity.x = -parent.RUNSPEED
				parent.frames()
				parent.turn(true)
				return states.DASH

			if parent.velocity.x > 0 and state == states.STAND:
				parent.velocity.x -= parent.TRACTION
				parent.velocity.x = clamp(parent.velocity.x, 0, parent.velocity.x)
			elif parent.velocity.x < 0 and state == states.STAND:
				parent.velocity.x += parent.TRACTION
				parent.velocity.x = clamp(parent.velocity.x, parent.velocity.x, 0)

		states.JUMP_SQUAT:
			if parent.frame == parent.jump_squat:
				if not Input.is_action_pressed("jump_%s" % id):
					parent.velocity.x = lerp(parent.velocity.x, 0.0, 0.08)
					parent.frames()
					return states.SHORT_HOP
				else:
					parent.velocity.x = lerp(parent.velocity.x, 0.0, 0.08)
					parent.frames()
					return states.FULL_HOP

		states.SHORT_HOP:
			parent.velocity.y = -parent.JUMPFORCE
			parent.frames()
			return states.AIR

		states.FULL_HOP:
			parent.velocity.y = -parent.MAX_JUMPFORCE
			parent.frames()
			return states.AIR

		states.DASH:
			if Input.is_action_pressed("jump_%s" % id):
				parent.frames()
				return states.JUMP_SQUAT


			elif Input.is_action_pressed("left_%s" % id):
				if parent.velocity.x > 0:
					parent.frames()
				parent.velocity.x = -parent.DASHSPEED
				if parent.frame <= parent.dash_duration-1:
					if Input.is_action_just_pressed("down_%s" % id):
						parent.frames()
						return states.MOONWALK
					parent.turn(true)
					return states.DASH
				else:
					parent.turn(true)
					parent.frames()
					return states.RUN

			elif Input.is_action_pressed("right_%s" % id):
				if parent.velocity.x < 0:
					parent.frames()
				parent.velocity.x = parent.DASHSPEED
				if parent.frame <= parent.dash_duration-1:
					if Input.is_action_just_pressed("down_%s" % id):
						parent.frames()
						return states.MOONWALK
					parent.turn(false)
					return states.DASH
				else:
					parent.turn(false)
					parent.frames()
					return states.RUN
			else:
				if parent.frame >= parent.dash_duration-1:
					for state in states:
						if state != "JUMP_SQUAT":
							parent.frames()
							return states.STAND

		states.MOONWALK:
			if Input.is_action_just_pressed("jump_%s" % id):
				parent.frames()
				return states.JUMP_SQUAT

			elif Input.is_action_pressed("left_%s" % id) && parent.direction() == 1:
				if parent.velocity.x > 0:
					parent.frames()
				parent.velocity.x += -parent.AIR_ACCEL * Input.get_action_strength("left_%s" % id)
				parent.velocity.x = clamp(parent.velocity.x, -parent.DASHSPEED*1.4, parent.velocity.x)
				if parent.frame <= parent.dash_duration*2:
					parent.turn(false)
					return states.MOONWALK
				else:
					parent.turn(true)
					parent.frames()
					return states.STAND

			elif Input.is_action_pressed("right_%s" % id) && parent.direction() == -1:
				if parent.velocity.x < 0:
					parent.frames()
				parent.velocity.x += parent.AIR_ACCEL * Input.get_action_strength("right_%s" % id)
				parent.velocity.x = clamp(parent.velocity.x, parent.velocity.x, parent.DASHSPEED * 1.5)
				if parent.frame <= parent.dash_duration*2:
					parent.turn(true)
					return states.MOONWALK
				else:
					parent.turn(false)
					parent.frames()
					return states.STAND

			else:
				if parent.frame >= parent.dash_duration-1:
					for state in states:
						if state != "JUMP_SQUAT":
							return states.STAND

		states.WALK:
			if Input.is_action_just_pressed("jump_%s" % id):
				parent.frames()
				return states.JUMP_SQUAT

			if Input.is_action_just_pressed("down_%s" % id):
				parent.frames()
				return states.CROUCH

			if Input.get_action_strength("left_%s" % id):
				parent.velocity.x = -parent.WALKSPEED * Input.get_action_strength("left_%s" % id)
				parent.turn(true)
			elif Input.get_action_strength("right_%s" % id):
				parent.velocity.x = parent.WALKSPEED * Input.get_action_strength("right_%s" % id)
				parent.turn(false)
			else:
				parent.frames()
				return states.STAND

		states.CROUCH:
			if Input.is_action_just_pressed("jump_%s" % id):
				parent.frames()
				return states.JUMP_SQUAT

			if Input.is_action_just_released("down_%s" % id):
				parent.frames()
				return states.STAND

			elif parent.velocity.x > 0:
				if parent.velocity.x > parent.RUNSPEED:
					parent.velocity.x += -(parent.TRACTION*4)
					parent.velocity.x = clamp(parent.velocity.x, 0, parent.velocity.x)
				else:
					parent.velocity.x += -(parent.TRACTION*4)
					parent.velocity.x = clamp(parent.velocity.x, 0, parent.velocity.x)

			elif parent.velocity.x < 0:
				if abs(parent.velocity.x) > parent.RUNSPEED:
					parent.velocity.x += (parent.TRACTION*4)
					parent.velocity.x = clamp(parent.velocity.x, parent.velocity.x, 0)
				else:
					parent.velocity.x += (parent.TRACTION/2)
					parent.velocity.x = clamp(parent.velocity.x, parent.velocity.x, 0)

		states.RUN:
			if Input.is_action_just_pressed("jump_%s" % id):
				parent.frames()
				return states.JUMP_SQUAT

			if Input.is_action_just_pressed("down_%s" % id):
				parent.frames()
				return states.CROUCH

			if Input.get_action_strength("left_%s" % id):
				if parent.velocity.x <= 0:
					parent.velocity.x = -parent.RUNSPEED
					parent.turn(true)
				else:
					parent.frames()
					return states.TURN
			elif Input.get_action_strength("right_%s" % id):
				if parent.velocity.x >= 0:
					parent.velocity.x = parent.RUNSPEED
					parent.turn(false)
				else:
					parent.frames()
					return states.TURN
			else:
				parent.frames()
				return states.STAND

		states.TURN:
			if Input.is_action_just_pressed("jump_%s" % id):
				parent.frames()
				return states.JUMP_SQUAT
			if parent.velocity.x > 0:
				parent.turn(true)
				parent.velocity.x += -parent.TRACTION*2
				parent.velocity.x = clamp(parent.velocity.x, 0 , parent.velocity.x)
			elif parent.velocity.x < 0:
				parent.turn(false)
				parent.velocity.x += parent.TRACTION*2
				parent.velocity.x = clamp(parent.velocity.x, parent.velocity.x, 0)
			else:
				if not Input.is_action_pressed("left_%s" % id) and not Input.is_action_pressed("right_%s" % id):
					parent.frames()
					return states.STAND
				else:
					parent.frames()
					return states.RUN

		states.AIR:
			AIRMOVEMENT()
			if Input.is_action_just_pressed("jump_%s" % id) and parent.airJump > 0:
				parent.fastfall = false
				parent.velocity.x = 0
				parent.velocity.y = -parent.DOUBLEJUMPFORCE
				parent.airJump -= 1
				if Input.is_action_pressed("left_%s" % id):
					parent.velocity.x = -parent.MAXAIRSPEED
				elif Input.is_action_pressed("right_%s" % id):
					parent.velocity.x = parent.MAXAIRSPEED

		states.LANDING:
			
			if parent.frame <= parent.landing_frames + parent.lag_frames:
				if parent.frame == 1:
					pass
				if parent.velocity.x > 0:
					parent.velocity.x = parent.velocity.x - parent.TRACTION/2
					parent.velocity.x = clamp(parent.velocity.x,0, parent.velocity.x)
				elif parent.velocity.x < 0:
					parent.velocity.x  = parent.velocity.x + parent.TRACTION/2
					parent.velocity.x = clamp(parent.velocity.x, parent.velocity.x, 0)
				if Input.is_action_just_pressed("jump_%s" % id):
					parent.frames()
					return states.JUMP_SQUAT
			else:
				if Input.is_action_pressed("down_%s" % id):
					parent.lag_frames = 0
					parent.frames()
					parent.reset_Jumps()
					return states.CROUCH
				else:
					parent.frames()
					parent.lag_frames = 0
					parent.reset_Jumps()
					return states.STAND
				parent.lag_frames = 0

		states.LEDGE_CATCH:
			if parent.frame > 7:
				parent.lag_frames = 0
				parent.reset_Jumps()
				parent.frames()
				return states.LEDGE_HOLD

		states.LEDGE_HOLD:
			if parent.frame >= 390:
				self.parent.position.y += -25
				parent.frames()
				return states.AIR

			if Input.is_action_just_pressed("down_%s" % id):
				parent.fastfall = true
				parent.regrab = 30
				parent.reset_ledge()
				self.parent.position.y += -25
				parent.catch = false
				parent.frames()
				return states.AIR

			elif parent.Ledge_Grab_F.get_target_position().x > 0:
				if Input.is_action_just_pressed("left_%s" % id):
					parent.velocity.x = (parent.AIR_ACCEL/2)
					parent.regrab = 30
					parent.reset_ledge()
					self.parent.position.y += -25
					parent.catch = false
					parent.frames()
					return states.AIR
				elif Input.is_action_just_pressed("right_%s" % id):
					parent.frames()
					return states.LEDGE_CLIMB
				elif Input.is_action_just_pressed("shield_%s" % id):
					parent.frames()
					return states.LEDGE_ROLL
				elif Input.is_action_just_pressed("jump_%s" % id):
					parent.frames()
					return states.LEDGE_JUMP

			elif parent.Ledge_Grab_F.get_target_position().x < 0:
				if Input.is_action_just_pressed("right_%s" % id):
					parent.velocity.x = (parent.AIR_ACCEL/2)
					parent.regrab = 30
					parent.reset_ledge()
					self.parent.position.y += -25
					parent.frames()
					return states.AIR
				elif Input.is_action_just_pressed("left_%s" % id):
					parent.frames()
					return states.LEDGE_CLIMB
				elif Input.is_action_just_pressed("shield_%s" % id):
					parent.frames()
					return states.LEDGE_ROLL
				elif Input.is_action_just_pressed("jump_%s" % id):
					parent.frames()
					return states.LEDGE_JUMP

		states.LEDGE_CLIMB:
			if parent.frame == 1:
				pass
			if parent.frame == 5:
				parent.position.y -= 25
			if parent.frame == 10:
				parent.position.y -= 25
			if parent.frame == 22:
				parent.catch = false
				parent.position.y -= 25
				parent.position.x += 50 * parent.direction()
			if parent.frame == 25:
				parent.velocity.y = 0
				parent.velocity.x = 0
				parent.move_and_collide(Vector2(parent.direction()*20, 50))
			if parent.frame == 30:
				parent.reset_ledge()
				parent.frames()
				return states.STAND

		states.LEDGE_JUMP:
			if parent.frame > 14:
				if Input.is_action_just_pressed("attack_%s" % id):
					parent.frames()
					return states.AIR_ATTACK
				if Input.is_action_just_pressed("special_%s" % id):
					parent.frames()
					return states.SPECIAL

			if parent.frame == 5:
				parent.reset_ledge()
				parent.position.y -= 20

			if parent.frame == 20:
				parent.catch = false
				parent.position.y -= 20
				if Input.is_action_just_pressed("jump_%s" % id) and parent.airJump > 0:
					parent.fastfall = false
					parent.velocity.y = -parent.DOUBLEJUMPFORCE
					parent.velocity.x = 0
					parent.airJump -= 1
					parent.frames()
					return states.AIR

			if parent.frame == 15:
				parent.position.y -= 20
				parent.velocity.y -= parent.DOUBLEJUMPFORCE
				parent.velocity.x += 220*parent.direction()
				if Input.is_action_just_pressed("jump_%s" % id) and parent.airJump > 0:
					parent.fastfall = false
					parent.velocity.y = -parent.DOUBLEJUMPFORCE
					parent.velocity.x = 0
					parent.airJump -= 1
					parent.frames()
					return states.AIR
				if Input.is_action_just_pressed("attack_%s"  % id):
					parent.frames()
					return states.AIR_ATTACK

				elif parent.frame > 15 and parent.frame < 20:
					parent.velocity.y += parent.FALLSPEED
					if Input.is_action_just_pressed("jump_%s" % id) and parent.airJump > 0:
						parent.fastfall = false
						parent.velocity.y = -parent.DOUBLEJUMPFORCE
						parent.velocity.x = 0
						parent.airJump -= 1
						parent.frames()
						return states.AIR
					if Input.is_action_just_pressed("attack_%s" % id):
						parent.frames()
						return states.AIR_ATTACK

				if parent.frame == 20:
					parent.frames()
					return states.AIR

		states.LEDGE_ROLL:
			if parent.frame == 1:
				pass
			if parent.frame == 5:
				parent.position.y -= 30
			if parent.frame == 10:
				parent.position.y -= 30

			if parent.frame == 20:
				parent.catch = false
				parent.position.y -= 30

			if parent.frame == 22:
				parent.position.y -= 30
				parent.position.x += 50*parent.direction()

			if parent.frame == 22 and parent.frame == 28:
				parent.position.x += 30 * parent.direction()

			if parent.frame == 29:
				parent.move_and_collide(Vector2(parent.direction()*20, 50))
			if parent.frame == 30:
				parent.velocity.y = 0
				parent.velocity.x = 0
				parent.reset_ledge()
				parent.frames()
				return states.STAND

func enter_state(new_state, old_state):
	match new_state:
		states.STAND:
			parent.play_animation('IDLE')
			return false
		states.DASH:
			parent.play_animation('DASH')
			return false
		states.MOONWALK:
			parent.play_animation('WALK')
			return false
		states.TURN:
			parent.play_animation('TURN')
			return false
		states.CROUCH:
			parent.play_animation('CROUCH')
			return false
		states.RUN:
			parent.play_animation('RUN')
			return false
		states.JUMP_SQUAT:
			parent.play_animation('JUMP_SQUAT')
			return false
		states.SHORT_HOP:
			parent.play_animation('AIR')
			return false
		states.FULL_HOP:
			parent.play_animation('AIR')
			return false
		states.AIR:
			parent.play_animation('AIR')
			return false
		states.LANDING:
			parent.play_animation('LANDING')
			return false
		states.LEDGE_CATCH:
			parent.play_animation('LEDGE_CATCH')
			return false
		states.LEDGE_HOLD:
			parent.play_animation('LEDGE_CATCH')
			return false
		states.LEDGE_JUMP:
			parent.play_animation('AIR')
			return false
		states.LEDGE_CLIMB:
			parent.play_animation('ROLL_FORWARD')
			return false
		states.LEDGE_ROLL:
			parent.play_animation('ROLL_FORWARD')
			return false

func exit_state(old_state, new_state):
	pass

func states_includes(state_array):
	for each_state in state_array:
		if state == each_state:
			return true
	return false

func AIRMOVEMENT():
	
	if parent.velocity.y < parent.FALLINGSPEED:
		parent.velocity.y += parent.FALLSPEED
	if Input.is_action_pressed("down_%s" % id): # and parent.down_buffer == 1 and parent.velocity.y > -150 and not parent.fastfall:
		parent.velocity.y = parent.MAXFALLSPEED
		parent.fastfall = true
	if parent.fastfall == true:
		parent.set_collision_mask_value(2, false)
		parent.velocity.y = parent.MAXFALLSPEED

	if abs(parent.velocity.x) >= abs(parent.MAXAIRSPEED):
		if parent.velocity.x > 0:
			if Input.is_action_pressed("left_%s" % id):
				parent.velocity.x += -parent.AIR_ACCEL
			elif Input.is_action_pressed("right_%s" % id):
				parent.velocity.x = parent.velocity.x
		if parent.velocity.x < 0:
			if Input.is_action_pressed("left_%s" % id):
				parent.velocity.x = parent.velocity.x
			elif Input.is_action_pressed("right_%s" % id):
				parent.velocity.x += parent.AIR_ACCEL


	elif abs(parent.velocity.x) < abs(parent.MAXAIRSPEED):
		if Input.is_action_pressed("left_%s" % id):
			parent.velocity.x += -parent.AIR_ACCEL
		if Input.is_action_pressed("right_%s" % id):
			parent.velocity.x += parent.AIR_ACCEL

	if not Input.is_action_pressed("left_%s" % id) and not Input.is_action_pressed("right_%s" % id):
		if parent.velocity.x < 0:
			parent.velocity.x += parent.AIR_ACCEL/5
		elif parent.velocity.x > 0:
			parent.velocity.x += -parent.AIR_ACCEL/5

func Landing():
	if states_includes([states.AIR]):
		if (parent.GroundL.is_colliding()) and parent.velocity.y > 0:
			var collider = parent.GroundL.get_collider()
			parent.frame = 0
			if parent.velocity.y > 0:
				parent.velocity.y = 0
			parent.fastfall = false
			return true

		elif parent.GroundR.is_colliding() and parent.velocity.y > 0:
			var collider2 = parent.GroundR.get_collider()
			parent.frame = 0
			if parent.velocity.y > 0:
				parent.velocity.y = 0
			parent.fastfall = false
			return true

func Falling():
	if states_includes([states.STAND,states.DASH,states.MOONWALK,states.RUN,states.CROUCH,states.WALK]):
		if not parent.GroundL.is_colliding() and not parent.GroundR.is_colliding():
			return true

func Ledge():
	if states_includes([states.AIR]):
		if (parent.Ledge_Grab_F.is_colliding()):
			print('colliding with ledge')
			var collider = parent.Ledge_Grab_F.get_collider()
			if collider.get_node('Label').text == 'Ledge_L' and !Input.get_action_strength("down_%s" % id) > 0.6 and parent.regrab == 0 && !collider.is_grabbed:
				if states_includes([states.AIR]):
					if parent.velocity.y < 0:
						return false
					parent.frame = 0
					parent.velocity.x = 0
					parent.velocity.y = 0
					self.parent.position.x = collider.position.x - 20
					self.parent.position.y = collider.position.y - 2
					parent.turn(false)
					parent.reset_Jumps()
					parent.fastfall = false
					collider.is_grabbed = true
					parent.last_ledge = collider
					return true

			if collider.get_node('Label').text == 'Ledge_R' and !Input.get_action_strength("down_%s" % id) > 0.6 and parent.regrab == 0 && !collider.is_grabbed:
				if states_includes([states.AIR]):
					if parent.velocity.y < 0:
						return false
					parent.frame = 0
					parent.velocity.x = 0
					parent.velocity.y = 0 
					self.parent.position.x = collider.position.x + 20
					self.parent.position.y = collider.position.x + 1
					parent.turn(false)
					parent.reset_Jumps()
					parent.fastfall = false
					collider.is_grabbed = true
					parent.last_ledge = collider
					return true

		if(parent.Ledge_Grab_B.is_colliding()):
			var collider = parent.Ledge_Grab_B.get_collider()
			if collider.get_node('Label').text == 'Ledge_L' and !Input.get_action_strength("down_%s" % id) > 0.6 and parent.regrab == 0 && !collider.is_grabbed:
				if states_includes([states.AIR]):
					if parent.velocity.y < 0:
						return false
					parent.frame = 0
					parent.velocity.x = 0
					parent.velocity.y = 0
					self.parent.position.x = collider.position.x - 20
					self.parent.position.y = collider.position.y - 1
					parent.turn(false)
					parent.reset_Jumps()
					parent.fastfall = false
					collider.is_grabbed = true
					parent.last_ledge = collider
					return true

			if collider.get_node('Label').text == 'Ledge_R' and !Input.get_action_strength("down_%s" % id) > 0.6 and parent.regrab == 0 && !collider.is_grabbed:
				if states_includes([states.AIR]):
					if parent.velocity.y < 0:
						return false
					parent.frame = 0
					parent.velocity.x = 0
					parent.velocity.y = 0 
					self.parent.position.x = collider.position.x + 20
					self.parent.position.y = collider.position.y + 1
					parent.turn(false)
					parent.reset_Jumps()
					parent.fastfall = false
					collider.is_grabbed = true
					parent.last_ledge = collider
					return true
