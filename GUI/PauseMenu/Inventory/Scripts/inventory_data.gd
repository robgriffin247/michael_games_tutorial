class_name InventoryData extends Resource

@export var slots: Array[SlotData]


func _init() -> void:
	connect_slots()


func add_item(item: ItemData, quantity: int = 1) -> bool:
	# If item exists in inventory
	for slot in slots:
		if slot:
			if slot.item_data == item:
				slot.quantity += quantity
				return true
	
	# If item is new
	for i in slots.size():
		if slots[i] == null:
			var new = SlotData.new()
			new.item_data = item
			new.quantity = quantity
			slots[i] = new
			new.changed.connect(slot_changed)
			return true
	
	print("Inventory full")
	return false


func connect_slots() -> void:
	for s in slots:
		if s:
			s.changed.connect(slot_changed)

func slot_changed() -> void:
	for s in slots:
		if s:
			if s.quantity < 1:
				s.changed.disconnect(slot_changed)
				var index = slots.find(s)
				slots[index] = null
				emit_changed()

# For saving:
# Gather data into an array
func get_save_date() -> Array:
	var item_save: Array = []
	for i in slots.size():
		item_save.append(item_to_save(slots[i]))
	
	return item_save

# Convert each item into a dictionary
func item_to_save(slot: SlotData) -> Dictionary:
	var result: Dictionary = {item_path = '', quantity = 0}
	if slot!=null:
		result.quantity = slot.quantity
		if slot.item_data != null:
			result.item_path = slot.item_data.resource_path
	
	return result


func parse_save_data(save_data: Array) -> void:
	var array_size = slots.size()
	slots.clear()
	slots.resize(array_size)
	for i in save_data.size():
		slots[i] = item_from_save(save_data[i])
	connect_slots()

func item_from_save(save_obj: Dictionary) -> SlotData:
	if save_obj.item_path == "":
		return null
	var new_slot: SlotData = SlotData.new()
	new_slot.item_data = load(save_obj.item_path)
	new_slot.quantity = int(save_obj.quantity)	
	return new_slot
