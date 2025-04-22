class_name HeartGUI extends Control

@onready var sprite: Sprite2D = $Sprite2D

var value: int = 2 : 
	set(_value): # this runs every time the value is updated
		value = _value
		update_sprite()

func update_sprite() -> void:
	sprite.frame = value
