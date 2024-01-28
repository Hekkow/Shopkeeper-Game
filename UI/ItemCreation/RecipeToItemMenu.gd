extends BaseGridMenu

func _ready():
	load_items(RecipeButton, Recipes.inventory.inv, Paths.item_display_button)