extends Table

func interact():
	SignalManager.emit_signal("ingredient_store_interacted")
