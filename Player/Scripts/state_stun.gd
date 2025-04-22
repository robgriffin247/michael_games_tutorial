class_name StateStun extends State

@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0
@export var invulnerable_duration: float = 1.0

var hurt_box: HurtBox
var direction: Vector2

var next_state: State = null

@onready var idle: State = $"../Idle"


func init() -> void:
	player.player_damaged.connect(_player_damaged)
	
	
# What happens when player enters/exits this state
func enter() -> void:
	player.animation_player.animation_finished.connect(_animation_finished)
	
	direction = player.global_position.direction_to(hurt_box.global_position)
	player.velocity = direction * -knockback_speed
	player.set_direction()
	
	player.update_animation("stun")

	player.make_invulnerable(invulnerable_duration)
	player.effect_animation_player.play("damaged")
	

func exit() -> void:
	next_state = null
	player.animation_player.animation_finished.disconnect(_animation_finished)


# What happens with frames/ticks in this state
func process( _delta ) -> State:	
	player.velocity -= player.velocity * decelerate_speed * _delta
	return next_state


func physics( _delta ) -> State:
	return null


# What happens with inputs in this state
func handle_input( _event: InputEvent ) -> State:
	return null

func _player_damaged( _hurt_box: HurtBox) -> void:
	hurt_box = _hurt_box
	state_machine.change_state(self)

func _animation_finished(_animation: String) -> void:
	next_state = idle
