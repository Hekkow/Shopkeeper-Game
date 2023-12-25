extends Button
class_name RecipeButton

var slot: InventorySlot

func _ready() -> void:
	text = str(slot)
	pressed.connect(on_recipe_pressed)

func on_recipe_pressed() -> void:
	SignalManager.emit_signal("recipe_pressed", slot.object)
	if slot.subtract() == 0:
		Recipes.inventory.remove(slot.object)
		queue_free()
		
	else:
		text = str(slot)
	
	

