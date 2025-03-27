class_name Enemy extends CharacterBody2D

signal direction_changed(new_direction: Vector2)
signal enemy_damaged(hurt_box: HurtBox)
signal enemy_destroyed(hurt_box: HurtBox)

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

@export var hp: int = 3

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var player: Player
var invulnerable: bool # prevents stunloops

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: Node = $EnemyStateMachine
@onready var hit_box: HitBox = $HitBox


func _ready() -> void:
	state_machine.initialize(self)
	player = PlayerManager.player
	hit_box.damaged.connect(_take_damage)

func _physics_process(_delta: float) -> void:
	move_and_slide()


func set_direction(_new_direction: Vector2) -> bool:
	#var new_direction: Vector2 = cardinal_direction
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
	if invulnerable:
		return
	hp -= hurt_box.damage
	if hp >0:
		enemy_damaged.emit(hurt_box)
	else:
		enemy_destroyed.emit(hurt_box)
