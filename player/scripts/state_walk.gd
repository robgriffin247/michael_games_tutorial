class_name StateWalk extends State

@export var walk_speed: float = 80.0
@onready var idle: State = $"../Idle"


# What happens when player enters/exits this state
func enter() -> void:
	player.update_animation("walk")


func exit() -> void:
	pass


# What ahappens with frames/ticks in this state
func process( delta ) -> State:
	if player.direction == Vector2.ZERO:
		return idle
	
	player.velocity = player.direction.normalized() * walk_speed
	
	if player.set_direction():
		player.update_animation("walk")
	
	return null



func physics( delta ) -> State:
	return null


# What happens with inputs in this state
func handle_input( delta ) -> State:
	return null
