class_name EnemyStateIdle extends EnemyState

@export var animation_name: String = "idle"
@export_category("AI")
@export var state_duration_min: float = 0.5
@export var state_duration_max: float = 1.5
@export var next_state: EnemyState

var _timer: float = 0.0

func init() -> void:
	pass

# What happens when player enters/exits this state
func enter() -> void:
	enemy.velocity = Vector2.ZERO
	_timer = randf_range(state_duration_min, state_duration_max)
	enemy.update_animation(animation_name)



func exit() -> void:
	pass


# What ahappens with frames/ticks in this state
func process( _delta ) -> EnemyState:
	_timer -= _delta
	if _timer <= 0:
		return next_state
	return null


func physics( _delta ) -> EnemyState:
	return null


# What happens with inputs in this state
func handle_input( _delta ) -> EnemyState:
	return null
