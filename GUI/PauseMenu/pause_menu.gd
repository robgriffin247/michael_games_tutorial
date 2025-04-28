extends CanvasLayer

@onready var audio_stream_player: AudioStreamPlayer = $Control/AudioStreamPlayer
@onready var button_save: Button = $Control/SaveLoadBox/Button_Save
@onready var button_load: Button = $Control/SaveLoadBox/Button_Load
@onready var item_description: Label = $Control/ItemDescription

signal shown
signal hidden

var is_paused: bool = false

func _ready() -> void:
	hide_pause_menu()
	button_save.pressed.connect(_on_save_pressed)
	button_load.pressed.connect(_on_load_pressed)



# Takes any inputs that have not been handled by another script
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("paused"):
		if not is_paused:
			show_pause_menu()
		else:
			hide_pause_menu()
		get_viewport().set_input_as_handled()


func show_pause_menu() -> void:
	get_tree().paused = true
	visible = true
	is_paused = true
	PlayerHud.visible = false
	shown.emit()
		
	
func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false
	PlayerHud.visible = true
	hidden.emit()
	
func _on_save_pressed() -> void:
	if not is_paused:
		return

	SaveManager.save_game()
	hide_pause_menu()
	
	
func _on_load_pressed() -> void:
	if not is_paused:
		return

	SaveManager.load_game()
	await LevelManager.level_load_started
	
	hide_pause_menu()	
	
	
func update_item_description(new_description: String) -> void:
	item_description.text = new_description


func play_audio(audio: AudioStream) -> void:
	audio_stream_player.stream = audio
	audio_stream_player.play()
