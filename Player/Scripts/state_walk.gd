class_name StateWalk extends State

@export var walk_speed: float = 140.0
@onready var idle: State = $"../Idle"
@onready var attack: State = $"../Attack"


func init() -> void:
	pass
	
# What happens when player enters/exits this state
func enter() -> void:
	player.update_animation("walk")


func exit() -> void:
	pass


# What happens with frames/ticks in this state
func process( _delta ) -> State:
	if player.direction == Vector2.ZERO:
		return idle
	
	player.velocity = player.direction * walk_speed
	
	if player.set_direction():
		player.update_animation("walk")
	
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
