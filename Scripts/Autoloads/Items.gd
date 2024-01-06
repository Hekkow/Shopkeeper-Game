extends Node

var id = 0
var store = []

func _ready() -> void:
    SignalManager.connect("customer_interested", on_customer_interested)

func on_customer_interested(_customer, item):
    remove_from_store(item)
    if len(store) == 0:
        SignalManager.emit_signal("store_closing")

func remove_from_store(item):
    for i in len(store):
        if store[i].equals(item):
            store.remove_at(i)
            return