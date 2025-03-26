class_name Player extends CharacterBody2D

var cardinal_direction: Vector2 = Vector2.DOWN
const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]
var direction: Vector2 = Vector2.ZERO


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine

signal direction_changed( new_direction: Vector2 )


func _ready() -> void:
	state_machine.initialize(self)


func _process(_delta: float) -> void:
	
	# Calculate direction
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized() 


func _physics_process(_delta: float) -> void:
	
	move_and_slide()


func set_direction() -> bool:
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
	
	
