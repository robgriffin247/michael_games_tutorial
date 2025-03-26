class_name EnemyStateMachine extends Node

var states: Array[EnemyState]
var previous_state: EnemyState
var current_state: EnemyState


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func _process(delta: float) -> void:
	change_state(current_state.process(delta))


func _physics_process(delta: float) -> void:
	change_state(current_state.physics(delta))


func initialize( _enemy: Enemy ) -> void:
	states = []
	
	for child in get_children():
		if child is EnemyState:
			states.append(child)

	for state in states:
		state.enemy = _enemy
		state.state_machine = self
		state.init()
		
	if states.size() > 0:
		change_state( states[0] )
		process_mode = Node.PROCESS_MODE_INHERIT


# This function changes the state 
func change_state(new_state: EnemyState) -> void:
	
	# If no new state passed into function
	if new_state == null:
		return
	
	# If there is a new state, then we need to exit the current
	if current_state: # Prevent error on first run
		current_state.exit()
	
	previous_state = current_state
	current_state = new_state
	
	current_state.enter()
