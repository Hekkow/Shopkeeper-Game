extends Button

class_name IngredientShopButton

var ingredient

func set_variables(_ingredient):
	ingredient = _ingredient
	text = ingredient.to_name() + " $" + str(ingredient.price)

func _pressed():
	SignalManager.emit_signal("shop_button_pressed", ingredient)