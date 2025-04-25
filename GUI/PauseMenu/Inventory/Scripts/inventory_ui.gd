class_name InventoryUI extends Node

const INVENTORY_SLOT = preload("res://GUI/PauseMenu/Inventory/inventory_slot.tscn")

var focus_index:int = 0

@export var data: InventoryData

func _ready() -> void:
	PauseMenu.shown.connect(update_inventory)
	PauseMenu.hidden.connect(clear_inventory)
	clear_inventory()
	data.changed.connect(on_inventory_changed)

func clear_inventory() -> void:
	for child in get_children():
		child.queue_free()

func update_inventory(i: int = 0) -> void:
	for s in data.slots:
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child(new_slot)
		new_slot.slot_data = s
		new_slot.focus_entered.connect(item_focused)
		
	await get_tree().process_frame
	get_child(focus_index).grab_focus()

func on_inventory_changed() -> void:
	var i = focus_index
	clear_inventory()
	update_inventory(i)

	
func item_focused() -> void:
	for i in get_child_count():
		if get_child(i).has_focus():
			focus_index = 1
			return
