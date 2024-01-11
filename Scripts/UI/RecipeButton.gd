"""

Button for individual recipe
Waits for item to be placed then removes this if needs to be removed

"""

extends Button
class_name RecipeButton

var slot: InventorySlot

func _ready() -> void:
	text = str(slot)
	SignalManager.connect("recipe_removed_from_inventory", on_recipe_removed_from_inventory)
	

func _pressed() -> void:
	SignalManager.emit_signal("recipe_pressed", slot.object)
	text = str(slot)

func on_recipe_removed_from_inventory(recipe_slot: InventorySlot):
	if slot != recipe_slot:
		return
	if slot.amount == 0:
		queue_free()
	else:
		text = str(slot)

	
	
	

