extends Node

#- item placement
signal item_spawned(item)
signal item_placed(case, item)
signal item_picked_up(case, item)

#- store opening
signal store_opened

#- customer shopping
signal customer_interested(item)
signal item_sold(item)
signal customer_left(customer)
signal player_money_updated(money)
signal store_closing
signal store_closed
signal customer_reached_queue(customer)
signal customer_reached_table(customer)
signal customer_leaving_line(customer)

#- haggling
signal haggling_started(customer)
signal haggling_ended(customer, score_multiplier)

#- scenes
signal change_scene(to)
signal scene_changing(to)
signal level_ready(level)

#- time
signal time_changed(time, day)

signal conversation_started(conversation)


signal shop_button_pressed(thing)
signal bought_item(thing)