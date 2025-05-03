@tool
class_name LevelTransition extends Area2D

enum SIDE {LEFT, RIGHT, TOP, BOTTOM}

@export_file("*.tscn") var level
@export var target_transition_area: String = "LevelTransition"

@export_category("Collision Area Settings")

@export var side: SIDE = SIDE.LEFT:
	set(_value):
		side = _value
		_update_area()

@export_range(1,12,1,"or_greater") var size: int = 2:
	set(_value):
		size = _value
		_update_area()
		
@export var snap_to_grid: bool = false:
	set(_value):
		_snap_to_grid()

@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	_update_area()
	if Engine.is_editor_hint():
		return
	
	monitoring = false
	_place_player()
	
	await LevelManager.level_loaded
	
	monitoring = true
	body_entered.connect(_player_entered)
	

func _player_entered(_player: Node2D) -> void:
	LevelManager.load_new_level(level, target_transition_area, get_offset())


func _place_player() -> void:
	if name != LevelManager.target_transition:
		return
	PlayerManager.set_player_position(global_position + LevelManager.position_offset)


func get_offset() -> Vector2:
	var offset: Vector2 = Vector2.ZERO
	var player_position = PlayerManager.player.position
	
	if side == SIDE.LEFT or side == SIDE.RIGHT:
		offset.y = player_position.y - global_position.y
	elif side == SIDE.TOP or side == SIDE.BOTTOM:
		offset.x = player_position.x - global_position.x
	
	if side == SIDE.LEFT:
		offset.x = -16
	elif side == SIDE.RIGHT:
		offset.x = 16
	elif side == SIDE.TOP:
		offset.y = -8
	elif side == SIDE.BOTTOM:
		offset.y = 40

	return offset

func _update_area() -> void:
	var new_rectangle: Vector2 = Vector2(32, 32)
	var new_position: Vector2 = Vector2.ZERO
	
	if side == SIDE.TOP:
		new_rectangle.x *= size
		new_position.y += -16 
		
	elif side == SIDE.BOTTOM:
		new_rectangle.x *= size
		new_position.y += 16
		
	elif side == SIDE.LEFT:
		new_rectangle.y *= size
		new_position.x += -16
	
	elif side == SIDE.RIGHT:
		new_rectangle.y *= size
		new_position.x += 16
	
	if collision_shape == null:
		collision_shape	= get_node("CollisionShape2D")
	
	collision_shape.shape.size = new_rectangle
	collision_shape.position = new_position
	
func _snap_to_grid() -> void:
	position.x = round(position.x/16)*16	
	position.y = round(position.y/16)*16	
	
	
