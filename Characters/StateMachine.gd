extends Node
class_name StateMachine

var state: int
var previous_state = null
var states = {}

@onready var parent: Character = get_parent()

func _physics_process(delta: float):
	if state != null:
		state_logic(delta)
		var transition = get_transition(delta)
		if transition != null:
			set_state(transition)
		parent.move_and_slide()

func state_logic(delta: float):
	pass

func get_transition(delta: float):
	return null

func enter_state(new_state: int, old_state: int):
	pass

func exit_state(old_state: int, new_state: int):
	pass

func set_state(new_state: int):
	previous_state = state
	state = new_state
	
	if previous_state !=null:
		exit_state(previous_state, new_state)
	if new_state !=null:
		enter_state(new_state, previous_state)

func add_state(state_name: String):
	states[state_name] = states.size()
