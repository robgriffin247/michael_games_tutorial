class_name StateIdle extends State

@onready var walk: StateWalk = $"../Walk"

# What happens when player enters/exits this state
func enter() -> void:
	player.update_animation("idle")


func exit() -> void:
	pass


# What ahappens with frames/ticks in this state
func process( delta ) -> State:
	if player.direction != Vector2.ZERO:
		return walk
	
	player.velocity = Vector2.ZERO
	return null



func physics( delta ) -> State:
	return null


# What happens with inputs in this state
func handle_input( delta ) -> State:
	return null
