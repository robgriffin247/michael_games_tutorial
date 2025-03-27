class_name EnemyStateStun extends EnemyState

@export var animation_name: String = "stun"
@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0

@export_category("AI")
@export var next_state: EnemyState

var _direction: Vector2
var _animation_finished: bool = false

func init() -> void:
	enemy.enemy_damaged.connect( _on_enemy_damaged)
	pass

# What happens when player enters/exits this state
func enter() -> void:
	enemy.invulnerable = true
	_animation_finished = false
	_direction = enemy.global_position.direction_to(enemy.player.global_position)
	
	enemy.set_direction(_direction)
	enemy.velocity = _direction.normalized() * -knockback_speed
	
	enemy.update_animation(animation_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	


func exit() -> void:
	enemy.invulnerable = false
	enemy.animation_player.animation_finished.disconnect(_on_animation_finished)



# What ahappens with frames/ticks in this state
func process( _delta ) -> EnemyState:
	if _animation_finished == true:
		return next_state
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null


func physics( _delta ) -> EnemyState:
	return null


# What happens with inputs in this state
func handle_input( _delta ) -> EnemyState:
	return null


func _on_enemy_damaged() -> void:
	state_machine.change_state(self)

func _on_animation_finished(_a: String) -> void:
	_animation_finished = true
