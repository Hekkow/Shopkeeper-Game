extends Node

#- maybe change some of these to regular paths later, in case it needs to much memory. hopefully not though

var character = load("res://Objects/Character/Character.tscn")

var item = load("res://Objects/Item/Item.tscn")
var item_class = load("res://Objects/Item/Item.gd")



var recipe_creation_menu = load("res://UI/RecipeCreation/RecipeCreationMenu.tscn")


var item_creation_menu = load("res://UI/ItemCreation/ItemCreationMenu.tscn")
var price_modal = load("res://UI/ItemCreation/PriceModal/PriceModal.tscn")
var item_display_button = load("res://UI/ItemCreation/ItemDisplayButton.tscn")

var haggling = load("res://Minigames/Haggling/Haggling.tscn")

var display_case_texture = load("res://Resources/Sprites/display_case.png")
var display_case_hover_texture = load("res://Resources/Sprites/display_case_hover.png")

var button_prompt = load("res://UI/ButtonPrompt.tscn")

var levels = "res://Levels/"
var resources = "res://Resources/"

var hud = "res://HUD/HUD.tscn"

var dialogic_characters = "res://Resources/DialogicCharacters/"
var dialogic_timelines = "res://Resources/Timelines/"
