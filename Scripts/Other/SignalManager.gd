extends Node
signal ingredient_added_to_pot(ingredient_slot)
signal ingredient_removed_from_inventory(ingredient_slot)
signal recipe_removed_from_inventory(recipe_slot)
signal ingredients_reset
signal item_sold(item)
signal price_set(item)
signal customer_interested(item)
signal player_money_updated(money)
signal pot_done
signal recipe_pressed(item)
signal store_opened
signal ingredient_to_recipe_menu_opened
signal recipe_to_item_menu_opened
signal recipe_made(recipe)
signal price_modal_spawned(item)
signal price_modal_despawned
signal escape_ingredient_to_recipe
signal escape_recipe_to_item
signal escape_recipe_to_item_price_modal
signal item_placed(case, item)
signal item_placement_cancelled(item)
signal item_picked_up(case, item)
signal invalid_price(message)
signal store_initialized
