extends Button
class_name IngredientButton

var slot: InventorySlot

func _ready():
	text = str(slot)
	pressed.connect(on_ingredient_pressed)

func on_ingredient_pressed() -> void:
	Data.add_to_inventory("Pot Ingredients", slot.object)
	SignalManager.emit_signal("ingredient_added", slot)
	if (slot.subtract() == 0):
		Data.remove_from_inventory("Ingredient Inventory", slot.object)
		queue_free()
	else:
		text = str(slot)
		