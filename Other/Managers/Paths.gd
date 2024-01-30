extends Node

#- maybe change some of these to regular paths later, in case it needs to much memory. hopefully not though

var character = load("res://Objects/Character/Character.tscn")

var item = load("res://Objects/Item/Item.tscn")

#- minigames
var haggling = load("res://Minigames/Haggling/Haggling.tscn")

var display_case_texture = load("res://Resources/Sprites/display_case.png")
var display_case_hover_texture = load("res://Resources/Sprites/display_case_hover.png")


#- folders
var levels = "res://Levels/"
var resources = "res://Resources/"
var dialogic_characters = "res://Resources/DialogicCharacters/"
var dialogic_timelines = "res://Resources/Timelines/"

#- ui
var ui = "res://UI/"
var button_prompt = load(ui + "ButtonPrompt.tscn")
var store_open_menus = load(ui + "StoreOpenMenus.tscn")
var craft_menu = load(ui + "CraftMenu.tscn")
var set_up_menu = load(ui + "SetUpMenu.tscn")
var ingredient_store_menu = load(ui + "IngredientStoreMenu.tscn")
var grid_button = load(ui + "GridButton.tscn")