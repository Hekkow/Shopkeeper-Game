"""

Background panel for recipe to item menu
Clicking it closes the price modal if it's opened
If it's not open, clicking the panel closes the entire menu

"""

extends Panel

var price_modal = false

func _ready():
	SignalManager.connect("recipe_pressed", can_click)
	SignalManager.connect("price_set", can_not_click)
	SignalManager.connect("item_placed", can_click)
	SignalManager.connect("price_modal_spawned", on_price_modal_spawned)
	SignalManager.connect("price_modal_despawned", on_price_modal_despawned)
	gui_input.connect(Callable(self, "on_panel_clicked"))

func on_price_modal_spawned(_recipe=null):
	price_modal = true
func on_price_modal_despawned():
	price_modal = false

func on_panel_clicked(event) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		escape()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		escape()

func escape():
	if price_modal:
		SignalManager.emit_signal("escape_recipe_to_item_price_modal")
	else:
		SignalManager.emit_signal("escape_recipe_to_item")

func can_click(_item=null):
	mouse_filter = Control.MOUSE_FILTER_STOP

func can_not_click(_item=null):
	mouse_filter = Control.MOUSE_FILTER_IGNORE