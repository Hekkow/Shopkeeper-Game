"""

Button for individual ingredient
Press removes button from inventory and adds it to pot

"""

extends Button
class_name IngredientButton

var slot: InventorySlot

func _ready():
	text = slot.to_str()
	pressed.connect(on_ingredient_pressed)
	SignalManager.connect("ingredient_removed_from_inventory", on_ingredient_removed_from_inventory)

func on_ingredient_removed_from_inventory(ingredient_slot: InventorySlot):
	if slot != ingredient_slot:
		return
	if slot.amount == 0:
		queue_free()
	else:
		text = slot.to_str()
	

func on_ingredient_pressed() -> void:
	SignalManager.emit_signal("ingredient_added_to_pot", slot)
	
		
