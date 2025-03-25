class_name Player extends CharacterBody2D

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var move_speed: float = 80.0
var state: String = "idle"


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	velocity = move_speed * direction.normalized()

	if set_state() or set_direction():
		update_animation()


func _physics_process(delta: float) -> void:
	
	move_and_slide()


func set_direction() -> bool:
	var new_direction: Vector2 = cardinal_direction
	if direction == Vector2.ZERO: # don't need to try to change direction if no directional input
		return false

	if direction.y == 0:
		new_direction = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_direction = Vector2.UP if direction.y < 0 else Vector2.DOWN	
	
	if new_direction == cardinal_direction: # did direction not change?
		return false
	
	cardinal_direction = new_direction
	
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	
	return true


func set_state() -> bool:
	var new_state: String = "idle" if direction == Vector2.ZERO else "walk"
	if new_state == state:
		return false
	
	state = new_state
	return true


func update_animation() -> void:
	animation_player.play(state + "_" + animation_direction())


func animation_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
	
	
