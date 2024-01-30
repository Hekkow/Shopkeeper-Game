extends Node

#- item placement
signal item_spawned(item)
signal item_placed(case, item)
signal item_picked_up(case, item)

#- store opening
signal store_opened
signal store_table_interacted

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
signal store_items_depleted


#- haggling
signal haggling_started(customer)
signal haggling_ended(customer, score_multiplier)

#- scenes
signal exit_triggered(exit_to)
signal scene_changing(to)
signal level_ready(level)

#- time
signal time_changed(time, day)

#- conversations
signal conversation_started(conversation)

#- buying
signal attempted_buy(thing)
signal bought_item(thing)

#- ui
signal craft_button_pressed
signal set_up_button_pressed
signal craft_menu_closed(pot)
signal ingredient_store_interacted

#- crafting
signal ingredient_added_to_pot
signal pot_pressed(recipe)

#- shop set up
signal item_created(item)