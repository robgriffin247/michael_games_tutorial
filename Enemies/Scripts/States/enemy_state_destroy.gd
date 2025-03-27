class_name EnemyStateDestroy extends EnemyState

@export var animation_name: String = "destroy"
@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0


var _damage_position: Vector2
var _direction: Vector2


func init() -> void:
	enemy.enemy_destroyed.connect( _on_enemy_destroyed)
	pass

# What happens when player enters/exits this state
func enter() -> void:
	enemy.invulnerable = true
	_direction = enemy.global_position.direction_to(_damage_position)
	
	enemy.set_direction(_direction)
	enemy.velocity = _direction.normalized() * -knockback_speed
	
	enemy.update_animation(animation_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	


func exit() -> void:
	pass


# What ahappens with frames/ticks in this state
func process( _delta ) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null


func physics( _delta ) -> EnemyState:
	return null


# What happens with inputs in this state
func handle_input( _delta ) -> EnemyState:
	return null


func _on_enemy_destroyed(hurt_box: HurtBox) -> void:
	_damage_position = hurt_box.global_position
	state_machine.change_state(self)

func _on_animation_finished(_a: String) -> void:
	enemy.queue_free()
