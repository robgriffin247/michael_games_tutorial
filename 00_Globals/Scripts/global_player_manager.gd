extends Node

# Preload the player scene
const PLAYER = preload("res://Player/Scenes/player.tscn")

var player: Player
var player_spawned = false


func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.2).timeout
	player_spawned = true

func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child(player)


func set_player_position(_new_position: Vector2) -> void:
	player.global_position = _new_position


func set_as_parent(_parent: Node2D) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	_parent.add_child(player)


func unparent_player(_parent: Node2D):
	_parent.remove_child(player)
