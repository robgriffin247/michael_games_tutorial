class_name PlayerStateMachine extends Node


var states: Array[State]
var previous_state: State
var current_state: State

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	change_state(current_state.process(delta))


func _physics_process(delta: float) -> void:
	change_state(current_state.physics(delta))


func _unhandled_input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))


func initialize( _player: Player ) -> void:
	states = []
	
	for child in get_children():
		if child is State:
			states.append(child)

	if states.size() == 0:
		return
	
	states[0].player = _player
	states[0].state_machine = self
	
	for state in states:
		state.init()
	
	change_state( states[0] )
	process_mode = Node.PROCESS_MODE_INHERIT


# This function changes the state 
func change_state(new_state: State) -> void:
	
	# If no new state passed into function
	if new_state == null:
		return
	
	# If there is a new state, then we need to exit the current
	if current_state: # Prevent error on first run
		current_state.exit()
	
	previous_state = current_state
	current_state = new_state
	
	current_state.enter()
