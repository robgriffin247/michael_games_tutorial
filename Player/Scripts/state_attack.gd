class_name StateAttack extends State

var attacking: bool = false

@export var attack_sound: AudioStream
@export_range(1, 20, 0.5) var decelerate_speed: float = 5

@onready var idle: StateIdle = $"../Idle"
@onready var walk: StateWalk = $"../Walk"

@onready var animation_player: AnimationPlayer = $"../../SpriteAnimationPlayer"
@onready var attack_effect_animation_player: AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AttackEffectAnimationPlayer"

@onready var audio: AudioStreamPlayer2D = $"../../Sounds/AudioStreamPlayer2D"
@onready var attack_hurt_box: HurtBox = %AttackHurtBox



func init() -> void:
	pass
	
# What happens when player enters/exits this state
func enter() -> void:
	player.update_animation("attack")
	attack_effect_animation_player.play("attack_" + player.animation_direction())
	animation_player.animation_finished.connect( end_attack )
	
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.3)
	audio.play()
	
	attacking = true
	
	await get_tree().create_timer(0.15).timeout
	if attacking:
		attack_hurt_box.monitoring = true
	


func exit() -> void:
	animation_player.animation_finished.disconnect( end_attack )
	attack_hurt_box.monitoring = false
	attacking = false
	
	
# What happens with frames/ticks in this state
func process( _delta ) -> State:	
	player.velocity -= player.velocity * decelerate_speed * _delta
	
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
	attack_hurt_box.monitoring = false
	attacking = false
	
