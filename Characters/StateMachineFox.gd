extends StateMachine
class_name StateMachineFox
var id: int
#@onready var id = parent.id

func _ready():
	id = parent.id
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
	add_state('HITSTUN')
	add_state('GROUND_ATTACK')
	add_state('DOWN_TILT')
	add_state('UP_TILT')
	add_state('FORWARD_TILT')
	add_state('AIR_ATTACK')
	add_state('NAIR')
	add_state('UAIR')
	add_state('BAIR')
	add_state('FAIR')
	add_state('DAIR')
	add_state('HITFREEZE')
	call_deferred("set_state", states.STAND)

func state_logic(delta):
	parent.updateframes(delta)
	parent._physics_process(delta)
	if parent.regrab > 0:
		parent.regrab -= 1
	parent.hit_pauses(delta)

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

	if Input.is_action_just_pressed("attack_%s" % id) && TILT() == true:
		parent.frames()
		return states.GROUND_ATTACK

	if Input.is_action_just_pressed("attack_%s" % id) && AIREAL() == true:
		if Input.is_action_pressed("up_%s" % id):
			parent.frames()
			return states.UAIR
		if Input.is_action_pressed("down_%s" % id):
			parent.frames()
			return states.DAIR
			match parent.direction():

				1:
					if Input.is_action_pressed("left_%s" % id):
						parent.frames()
						return states.BAIR
					if Input.is_action_pressed("right_%s" % id):
						parent.frames()
						return states.FAIR

				-1:
					if Input.is_action_pressed("right_%s" % id):
						parent.frames()
						return states.BAIR
					if Input.is_action_pressed("left_%s" % id):
						parent.frames()
						return states.FAIR

		parent.frames()
		return states.NAIR

	if Input.is_action_pressed("shield_%s" % id) && AIREAL() && parent.cooldown == 0:
		parent.l_cancel = 11
		parent.cooldown = 40

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
				parent.velocity.x = parent.RUN_SPEED
				parent.frames()
				parent.turn(false)
				return states.DASH

			if Input.get_action_strength("left_%s" % id) == 1:
				parent.velocity.x = -parent.RUN_SPEED
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
				if (Input.is_action_pressed("shield_%s" % id)) and (Input.is_action_pressed("left_%s" % id)) or (Input.is_action_pressed("right_%s" % id)):
					if Input.is_action_pressed("right_%s" % id):
						parent.velocity.x = parent.AIR_DODGE_SPEED/parent.perfect_wavedash_modifier
					if Input.is_action_pressed("left_%s" % id):
						parent.velocity.x = -parent.AIR_DODGE_SPEED/parent.perfect_wavedash_modifier
					parent.lag_frames = 6
					parent.frames()
					return states.LANDING
				if not Input.is_action_pressed("jump_%s" % id):
					parent.velocity.x = lerp(parent.velocity.x, 0.0, 0.08)
					parent.frames()
					return states.SHORT_HOP
				else:
					parent.velocity.x = lerp(parent.velocity.x, 0.0, 0.08)
					parent.frames()
					return states.FULL_HOP

		states.SHORT_HOP:
			parent.velocity.y = -parent.JUMP_FORCE
			parent.frames()
			return states.AIR

		states.FULL_HOP:
			parent.velocity.y = -parent.MAX_JUMP_FORCE
			parent.frames()
			return states.AIR

		states.DASH:
			if Input.is_action_just_pressed("jump_%s" % id):
				parent.frames()
				return states.JUMP_SQUAT


			elif Input.is_action_pressed("left_%s" % id):
				if parent.velocity.x > 0:
					parent.frames()
				parent.velocity.x = -parent.DASH_SPEED
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
				parent.velocity.x = parent.DASH_SPEED
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
				parent.velocity.x = clamp(parent.velocity.x, -parent.DASH_SPEED*1.4, parent.velocity.x)
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
				parent.velocity.x = clamp(parent.velocity.x, parent.velocity.x, parent.DASH_SPEED * 1.5)
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
				parent.velocity.x = -parent.WALK_SPEED * Input.get_action_strength("left_%s" % id)
				parent.turn(true)
			elif Input.get_action_strength("right_%s" % id):
				parent.velocity.x = parent.WALK_SPEED * Input.get_action_strength("right_%s" % id)
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
				if parent.velocity.x > parent.RUN_SPEED:
					parent.velocity.x += -(parent.TRACTION*4)
					parent.velocity.x = clamp(parent.velocity.x, 0, parent.velocity.x)
				else:
					parent.velocity.x += -(parent.TRACTION*4)
					parent.velocity.x = clamp(parent.velocity.x, 0, parent.velocity.x)

			elif parent.velocity.x < 0:
				if abs(parent.velocity.x) > parent.RUN_SPEED:
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
					parent.velocity.x = -parent.RUN_SPEED
					parent.turn(true)
				else:
					parent.frames()
					return states.TURN
			elif Input.get_action_strength("right_%s" % id):
				if parent.velocity.x >= 0:
					parent.velocity.x = parent.RUN_SPEED
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
			if Input.is_action_just_pressed("jump_%s" % id) and parent.air_jumps > 0:
				parent.fastfall = false
				parent.velocity.x = 0
				parent.velocity.y = -parent.DOUBLE_JUMP_FORCE
				parent.air_jumps -= 1
				if Input.is_action_pressed("left_%s" % id):
					parent.velocity.x = -parent.MAX_AIR_SPEED
				elif Input.is_action_pressed("right_%s" % id):
					parent.velocity.x = parent.MAX_AIR_SPEED

		states.LANDING:
			if parent.frame == 1:
				if parent.l_cancel > 0:
					parent.lag_frames = floor(parent.lag_frames / 2)
			if parent.frame <= parent.landing_frames + parent.lag_frames:
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
			if parent.frame == 1:
				parent.position.y -= 20
				parent.velocity.y -= parent.LEDGE_JUMP_FORCE
				parent.velocity.x += parent.LEDGE_JUMP_DIRECTION_FORCE*parent.direction()
				return states.LEDGE_JUMP
			
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
				if Input.is_action_just_pressed("jump_%s" % id) and parent.air_jumps > 0:
					parent.fastfall = false
					parent.velocity.y = -parent.DOUBLE_JUMP_FORCE
					parent.velocity.x = 0
					parent.air_jumps -= 1
					parent.frames()
					return states.AIR

			if parent.frame == 15 or parent.frame == 20:
				parent.frames()
				return states.AIR
	
			if Input.is_action_just_pressed("jump_%s" % id) and parent.air_jumps > 0:
				parent.fastfall = false
				parent.velocity.y = -parent.DOUBLE_JUMP_FORCE
				parent.velocity.x = 0
				parent.air_jumps -= 1
				parent.frames()
				return states.AIR
				
			if Input.is_action_just_pressed("attack_%s"  % id):
				parent.frames()
				return states.AIR_ATTACK
			elif parent.frame > 15 and parent.frame < 20:
				parent.velocity.y += parent.FALL_SPEED
				if Input.is_action_just_pressed("jump_%s" % id) and parent.air_jumps > 0:
					parent.fastfall = false
					parent.velocity.y = -parent.DOUBLE_JUMP_FORCE
					parent.velocity.x = 0
					parent.air_jumps -= 1
					parent.frames()
					return states.AIR
				if Input.is_action_just_pressed("attack_%s" % id):
					parent.frames()
					return states.AIR_ATTACK

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

		states.GROUND_ATTACK:
			#if Input.is_action_pressed("up_%s" % id):
				#parent.frames()
				#return states.UP_TILT

			if Input.is_action_pressed("down_%s" % id):
				parent.frames()
				return states.DOWN_TILT

			#if Input.is_action_pressed("left_%s" % id):
				#parent.turn(true)
				#parent.frames()
				#return states.FORWARD_TILT

			#if Input.is_action_pressed("right_%s" % id):
				#parent.turn(false)
				#parent.frames()
				#return states.FORWARD_TILT
			parent.frames()
			return states.DOWN_TILT

		states.DOWN_TILT:
			if parent.frame == 0:
				parent.DOWN_TILT()

			if parent.frame >= 1:
				if parent.velocity.x > 0:
					parent.velocity.x += -parent.TRACTION*3
					parent.velocity.x = clamp(parent.velocity.x, 0, parent.velocity.x)
				elif parent.velocity.x < 0:
					parent.velocity.x += parent.TRACTION*3
					parent.velocity.x = clamp(parent.velocity.x, parent.velocity.x, 0)
			if parent.DOWN_TILT() == true:
				if Input.is_action_pressed("down_%s" % id):
					parent.frames()
					return states.CROUCH
				else:
					parent.frames()
					return states.STAND

		states.UP_TILT:
			pass

		states.FORWARD_TILT:
			pass

		states.HITSTUN:
			if parent.knockback >= 3:
				var bounce = parent.move_and_collide(parent.velocity * delta)
				if bounce:
					parent.velocity = parent.velocity.bounce(bounce.get_normal())  * .8
					parent.hitstun = round(parent.hitstun * .8)
			if parent.velocity.y < 0:
				parent.velocity.y += parent.vdecay * 0.5 * Engine.time_scale
				parent.velocity.y = clamp(parent.velocity.y, parent.velocity.y, 0)
			if parent.velocity.x < 0:
				parent.velocity.x += (parent.hdecay) * 0.4 * -1 * Engine.time_scale
				parent.velocity.x = clamp(parent.velocity.x, 0, parent.velocity.x)
			elif parent.velocity.x > 0:
				parent.velocity.x -= parent.hdecay * 0.4 * Engine.time_scale 
				parent.velocity.x = clamp(parent.velocity.x, 0, parent.velocity.x)

			if parent.frame == parent.hitstun:
				if parent.knockback >= 24:
					parent.frames()
					return states.AIR
				else:
					parent.frames()
					return states.AIR
			elif parent.frame > 60 * 5:
				return states.AIR

		states.AIR_ATTACK:
			AIRMOVEMENT()
			if Input.is_action_pressed("up_%s" % id):
				parent.frames()
				return states.UAIR

			if Input.is_action_pressed("down_%s" % id):
				parent.frames()
				return states.DAIR
			match parent.direction():

				1:
					if Input.is_action_pressed("left_%s" % id):
						parent.frames()
						return states.BAIR

					if Input.is_action_pressed("right_%s" % id):
						parent.frames()
						return states.FAIR

				-1:
					if Input.is_action_pressed("right_%s" % id):
						parent.frames()
						return states.BAIR

					if Input.is_action_pressed("left_%s" % id):
						parent.frames()
						return states.FAIR

			parent.frames()
			return states.NAIR

		states.NAIR:
			AIRMOVEMENT()
			if parent.frame == 0:
				print('nair')
				parent.NAIR()
			if parent.NAIR() == true:
				parent.lag_frames = 0
				parent.frames()
				return states.AIR
			elif parent.frame < 5:
				parent.lag_frames = 0
			elif parent.frame > 15:
				parent.lag_frames = 0
			else:
				parent.lag_frames = 7

		states.UAIR:
			AIRMOVEMENT()
			if parent.frame == 0:
				print('uair')
				parent.UAIR()
			if parent.UAIR() == true:
				parent.lag_frames = 0
				parent.frames()
				return states.AIR
			else:
				parent.lag_frames = 13

		states.BAIR:
			AIRMOVEMENT()
			if parent.frame == 0:
				print('bair')
				parent.BAIR()
			if parent.BAIR() == true:
				parent.lag_frames = 0
				parent.frames()
				return states.AIR
			else:
				parent.lag_frames = 9

		states.FAIR:
			AIRMOVEMENT()
			if Input.is_action_just_pressed("jump_%s" % id) and parent.air_jumps > 0:
				parent.fastfall = false
				parent.velocity.x = 0
				parent.velocity.y = -parent.DOUBLE_JUMP_FORCE
				parent.air_jumps -= 1
				if Input.is_action_pressed("left_%s" % id):
					parent.velocity.x = -parent.MAX_AIR_SPEED
				elif Input.is_action_pressed("right_%s" % id):
					parent.velocity.x = parent.MAX_AIR_SPEED
				return states.AIR
			if parent.frame == 0:
				print('fair')
				parent.FAIR()
			if parent.FAIR() == true:
				parent.lag_frames = 30
				parent.frames()
				return states.FAIR
			else:
				parent.lag_frames = 18

		states.DAIR:
			AIRMOVEMENT()
			if parent.frame == 0:
				print('dair')
				parent.DAIR()
			if parent.DAIR() == true:
				parent.lag_frames = 0
				parent.frames()
				return states.AIR
			else:
				parent.lag_frames = 17

		states.HITFREEZE:
			if parent.freezeframes == 0:
				parent.frames()
				parent.veloctiy.x = kbx
				parent.veloctiy.y = kby
				parent.hdecay = hd
				parent.vdecay = vd
				return states.HITSTUN
			parent.position = pos

func enter_state(new_state, old_state):
	match new_state:
		states.STAND:
			parent.play_animation('IDLE')
			parent.states.text = str('STAND')
			return false
		states.DASH:
			parent.play_animation('DASH')
			parent.states.text = str('DASH')
			return false
		states.MOONWALK:
			parent.play_animation('WALK')
			parent.states.text = str('MOONWALK')
			return false
		states.TURN:
			parent.play_animation('TURN')
			parent.states.text = str('TURN')
			return false
		states.CROUCH:
			parent.play_animation('CROUCH')
			parent.states.text = str('CROUCH')
			return false
		states.RUN:
			parent.play_animation('RUN')
			parent.states.text = str('RUN')
			return false
		states.JUMP_SQUAT:
			parent.play_animation('JUMP_SQUAT')
			parent.states.text = str('JUMP_SQUAT')
			return false
		states.SHORT_HOP:
			parent.play_animation('AIR')
			parent.states.text = str('SHORT_HOP')
			return false
		states.FULL_HOP:
			parent.play_animation('AIR')
			parent.states.text = str('FULL_HOP')
			return false
		states.AIR:
			parent.play_animation('AIR')
			parent.states.text = str('AIR')
			return false
		states.LANDING:
			parent.play_animation('LANDING')
			parent.states.text = str('LANDING')
			return false
		states.LEDGE_CATCH:
			parent.play_animation('LEDGE_CATCH')
			parent.states.text = str('LEDGE_CATCH')
			return false
		states.LEDGE_HOLD:
			parent.play_animation('LEDGE_CATCH')
			parent.states.text = str('LEDGE_HOLD')
			return false
		states.LEDGE_JUMP:
			parent.play_animation('AIR')
			parent.states.text = str('LEDGE_JUMP')
			return false
		states.LEDGE_CLIMB:
			parent.play_animation('ROLL_FORWARD')
			parent.states.text = str('LEDGE_CLIMB')
			return false
		states.LEDGE_ROLL:
			parent.play_animation('ROLL_FORWARD')
			parent.states.text = str('LEDGE_ROLL')
			return false
		states.GROUND_ATTACK:
			parent.states.text = str('GROUND_ATTACK')
			return false
		states.DOWN_TILT:
			parent.play_animation('DOWN_TILT')
			parent.states.text = str('DOWN_TILT')
			return false
		states.UP_TILT:
			pass
			#parent.play_animation('UP_TILT')
			#parent.states.text = str('UP_TILT')
			#return false
		states.FORWARD_TILT:
			pass
			#parent.play_animation('FORWARD_TILT')
			#parent.states.text = str('FORWARD_TILT')
			#return false
		states.HITSTUN:
			parent.play_animation('HITSTUN')
			parent.states.text = str('HITSTUN')
			return false
		states.AIR_ATTACK:
			parent.states.text = str('AIR_ATTACK')
			return false
		states.NAIR:
			parent.play_animation('NAIR')
			parent.states.text = str('NAIR')
			return false
		states.UAIR:
			parent.play_animation('UAIR')
			parent.states.text = str('UAIR')
			return false
		states.BAIR:
			parent.play_animation('BAIR')
			parent.states.text = str('BAIR')
			return false
		states.FAIR:
			parent.play_animation('FAIR')
			parent.states.text = str('FAIR')
			return false
		states.DAIR:
			parent.play_animation('DAIR')
			parent.states.text = str('DAIR')
			return false
		states.HITFREEZE:
			parent.play_animation('HITSTUN') 
			parent.states.text = str('HITFREEZE')
			return false

func exit_state(old_state, new_state):
	pass

func states_includes(state_array):
	for each_state in state_array:
		if state == each_state:
			return true
	return false

func TILT():
	if states_includes([states.STAND,states.MOONWALK,states.DASH,states.RUN,states.WALK,states.CROUCH]):
		return true

func AIREAL():
	if states_includes([states.AIR, states.NAIR, states.DAIR]):
		if !(parent.GroundL.is_colliding() and parent.GroundR.is_colliding()):
			return true
		else:
			return false

func AIRMOVEMENT():
	
	if parent.velocity.y < parent.FALLING_SPEED:
		parent.velocity.y += parent.FALL_SPEED
	if Input.is_action_pressed("down_%s" % id): #and parent.down_buffer == 1 and parent.velocity.y > -150 and not parent.fastfall:
		parent.velocity.y = parent.MAX_FALL_SPEED
		parent.fastfall = true
	if parent.fastfall == true:
		parent.set_collision_mask_value(2, false)
		parent.velocity.y = parent.MAX_FALL_SPEED

	if abs(parent.velocity.x) >= abs(parent.MAX_AIR_SPEED):
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


	elif abs(parent.velocity.x) < abs(parent.MAX_AIR_SPEED):
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
	if states_includes([states.AIR, states.NAIR, states.UAIR, states.DAIR, states.BAIR, states.FAIR]):
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
					parent.GRAVITY = true

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
					parent.GRAVITY = true

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
					parent.GRAVITY = true

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
					parent.GRAVITY = true

var kbx
var kby
var hd
var vd
var pos

func hitfreeze(duration: float, knockback: Array):
	pos = parent.get_position()
	parent.freezeframes = duration
	kbx = knockback[0]
	kby = knockback[1]
	hd = knockback[2]
	vd = knockback[3]
