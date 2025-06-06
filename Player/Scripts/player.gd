class_name Player extends CharacterBody2D

signal direction_changed( new_direction: Vector2 )
signal player_damaged(hurt_box: HurtBox)

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO

var invulnerable: bool = false
var hp: int = 6
var max_hp: int = 6

@onready var animation_player: AnimationPlayer = $SpriteAnimationPlayer
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
@onready var hit_box: HitBox = $HitBox
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine



func _ready() -> void:
	PlayerManager.player = self
	state_machine.initialize(self)
	hit_box.damaged.connect(_take_damage)
	update_hp(99)


func _process(_delta: float) -> void:
	
	# Calculate direction
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized() 

func _physics_process(_delta: float) -> void:
	
	move_and_slide()


func set_direction() -> bool:
	if direction == Vector2.ZERO: # don't need to try to change direction if no directional input
		return false

	var direction_id: int = int(round( (direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size() ))
	var new_direction = DIR_4[direction_id]
	
	if direction.y == 0:
		new_direction = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_direction = Vector2.UP if direction.y < 0 else Vector2.DOWN	
	
	if new_direction == cardinal_direction: # did direction not change?
		return false
	
	direction_changed.emit(new_direction)
	
	cardinal_direction = new_direction
	
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	
	return true


func update_animation(state: String) -> void:
	animation_player.play(state + "_" + animation_direction())


func animation_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
	
	
func _take_damage(hurt_box: HurtBox) -> void:
	if invulnerable==true:
		return
	
	update_hp(-hurt_box.damage)
	if hp>0:
		player_damaged.emit(hurt_box)
	else:
		player_damaged.emit(hurt_box)
		update_hp(99)


func update_hp(delta: int) -> void:
	hp = clampi(hp+delta, 0, max_hp)
	PlayerHud.update_hp(hp, max_hp)
	

func make_invulnerable(_duration: float = 1.0) -> void:
	invulnerable = true
	hit_box.monitoring = false
	await get_tree().create_timer(_duration).timeout
	invulnerable = false
	hit_box.monitoring = true
