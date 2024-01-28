extends Button
class_name IngredientButton

var slot: InventorySlot

func _ready():
	pressed.connect(on_ingredient_pressed)
	SignalManager.connect("ingredient_removed_from_inventory", on_ingredient_removed_from_inventory)

func on_ingredient_removed_from_inventory(ingredient_slot: InventorySlot):
	if slot != ingredient_slot:
		return
	if slot.amount == 0:
		queue_free()
	else:
		text = slot.to_str()
	

func set_variables(_slot):
	slot = _slot
	text = slot.to_str()

func on_ingredient_pressed():
	SignalManager.emit_signal("ingredient_added_to_pot", slot)
	
		
