class_name EnemyState extends Node

var enemy: Enemy
var state_machine: EnemyStateMachine


func init() -> void:
	pass

# What happens when player enters/exits this state
func enter() -> void:
	pass


func exit() -> void:
	pass


# What ahappens with frames/ticks in this state
func process( _delta ) -> EnemyState:
	return null


func physics( _delta ) -> EnemyState:
	return null


# What happens with inputs in this state
func handle_input( _delta ) -> EnemyState:
	return null
