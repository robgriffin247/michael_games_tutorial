class_name EnemyStateWander extends EnemyState

@export var animation_name: String = "walk"
@export var walk_speed: float = 20.0

@export_category("AI")
@export var state_animation_duration: float = 0.7
@export var state_cycles_min: int = 1
@export var state_cycles_max: int = 5
@export var next_state: EnemyState

var _timer: float = 0.0
var _direction: Vector2

func init() -> void:
	pass

# What happens when player enters/exits this state
func enter() -> void:
	_timer = randi_range(state_cycles_min, state_cycles_max) * state_animation_duration
	var rand = randi_range(0, 3)
	_direction = enemy.DIR_4[rand]
	enemy.velocity = _direction.normalized() * walk_speed
	enemy.set_direction(_direction)
	enemy.update_animation(animation_name)



func exit() -> void:
	pass


# What ahappens with frames/ticks in this state
func process( _delta ) -> EnemyState:
	_timer -= _delta
	if _timer < 0:
		return next_state
	return null


func physics( _delta ) -> EnemyState:
	return null


# What happens with inputs in this state
func handle_input( _delta ) -> EnemyState:
	return null
