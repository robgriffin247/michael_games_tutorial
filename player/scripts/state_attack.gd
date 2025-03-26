class_name StateAttack extends State

var attacking: bool = false

@onready var idle: StateIdle = $"../Idle"
@onready var walk: StateWalk = $"../Walk"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

# What happens when player enters/exits this state
func enter() -> void:
	player.update_animation("attack")
	animation_player.animation_finished.connect( end_attack )
	attacking = true


func exit() -> void:
	animation_player.animation_finished.disconnect( end_attack )
	attacking = false
	pass
	
# What happens with frames/ticks in this state
func process( _delta ) -> State:	
	player.velocity = Vector2.ZERO
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
		
	return null


func physics( _delta ) -> State:
	return null


# What happens with inputs in this state
func handle_input( _event: InputEvent ) -> State:
	return null


func end_attack( _new_animation_name: String ) -> void:
	attacking = false
	
