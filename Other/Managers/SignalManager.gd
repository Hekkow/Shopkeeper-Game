extends Node

#- ingredient to recipe
signal ingredient_to_recipe_menu_opened
signal escape_ingredient_to_recipe
signal ingredient_added_to_pot(ingredient_slot)
signal ingredients_reset
signal ingredient_removed_from_inventory(ingredient_slot)
signal recipe_made(recipe)
signal pot_done

#- recipe to item
signal recipe_to_item_menu_opened
signal escape_recipe_to_item
signal escape_recipe_to_item_price_modal
signal recipe_pressed(item)
signal recipe_removed_from_inventory(recipe_slot)

#- price modal
signal price_modal_spawned(item)
signal price_modal_despawned
signal invalid_price(message)
signal price_set(item)

#- item placement
signal item_spawned(item)
signal item_placed(case, item)
signal item_placement_cancelled(item)
signal item_picked_up(case, item)

#- store opening
signal store_initialized
signal store_opened
signal customer_spawned(customer)

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


signal recipes_ready
#- haggling
signal haggling_started(customer)
signal haggling_ended(customer, score_multiplier)
signal haggling_done
#- scenes
signal change_scene(to)
signal scene_changing(to)
signal scene_changed(to)
signal level_ready(level)

#- time
signal time_changed(time, day)

signal conversation_started(conversation)
signal ingredient_store_interacted
signal shop_button_pressed(thing)