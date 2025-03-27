class_name HurtBox extends Area2D

@export var damage: int = 1

func _ready() -> void:
	area_entered.connect( a_entered )

func a_entered(a) -> void:
	if a is HitBox:
		a.take_damage( self )
	
