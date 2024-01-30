extends CustomUI

@onready var grid_menu = $GridMenu

func _ready():
	grid_menu.load_items(Recipes.inventory.inv, create_item)

func create_item(_button, recipe):
	SignalManager.emit_signal("item_created", Item.new(recipe.object))