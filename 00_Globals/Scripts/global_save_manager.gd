extends Node


const SAVE_PATH = "user://"

signal game_loaded
signal game_saved

var current_save: Dictionary = {
	scene_path = "",
	player = {
		hp = 6,
		max_hp = 6,
		pos_x = 0,
		pos_y = 0
	},
	items = [],
	persistence = [],
	quests = [],
}

func save_game():
	update_player_data()
	update_scene_path()
	update_item_data()
	
	var file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.WRITE)
	var save_json = JSON.stringify(current_save)
	
	file.store_line(save_json)
	game_saved.emit()
	
	
func load_game():
	var file: FileAccess = FileAccess.open(SAVE_PATH + "save.sav", FileAccess.READ)
	var json = JSON.new()
	json.parse(file.get_line())
	var save_dict: Dictionary = json.get_data() as Dictionary
	current_save = save_dict
	
	LevelManager.load_new_level(current_save.scene_path, "", Vector2.ZERO)
	
	await LevelManager.level_load_started
	
	PlayerManager.set_player_position(
		Vector2(
			current_save.player.pos_x,
			current_save.player.pos_y
		)
	)
	
	PlayerManager.set_health(current_save.player.hp, current_save.player.max_hp)

	PlayerManager.INVENTORY_DATA.parse_save_data(current_save.items)
	
	await LevelManager.level_loaded
	
	game_loaded.emit()



func update_player_data() -> void:
	var p = PlayerManager.player
	current_save.player.hp = p.hp
	current_save.player.max_hp = p.max_hp
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y

func update_scene_path() -> void:
	var p: String = ""
	for child in get_tree().root.get_children():
		if child is Level:
			p = child.scene_file_path
	current_save.scene_path = p

func update_item_data() -> void:
	current_save.items = PlayerManager.INVENTORY_DATA.get_save_date()


func add_persistent_value(value: String) -> void:
	if check_persistent_value(value) == false:
		current_save.persistence.append(value)

func check_persistent_value(value: String) -> bool:
	var p = current_save.persistence as Array
	return p.has(value)
