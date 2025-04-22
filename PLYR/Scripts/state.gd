class_name State extends Node

static var player: Player
static var state_machine: PlayerStateMachine

func _ready() -> void:
	pass


# What happens when player enters/exits this state
func enter() -> void:
	pass


func exit() -> void:
	pass


# What ahappens with frames/ticks in this state
func process( _delta ) -> State:
	return null


func physics( _delta ) -> State:
	return null


# What happens with inputs in this state
func handle_input( _delta ) -> State:
	return null
