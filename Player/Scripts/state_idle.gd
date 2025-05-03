class_name StateIdle extends State

@onready var walk: State = $"../Walk"
@onready var attack: State = $"../Attack"

func init() -> void:
	pass
	
# What happens when player enters/exits this state
func enter() -> void:
	player.update_animation("idle")


func exit() -> void:
	pass


# What ahappens with frames/ticks in this state
func process( _delta ) -> State:
	if player.direction != Vector2.ZERO:
		return walk
	
	player.velocity = Vector2.ZERO
	return null



func physics( _delta ) -> State:
	return null


# What happens with inputs in this state
func handle_input( _event: InputEvent ) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	
	if _event.is_action_pressed("interact"):
		PlayerManager.interact_pressed.emit()
	return null
