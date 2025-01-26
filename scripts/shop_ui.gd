extends Control

@onready var shop_grid = $MainContainer/ShopBackground/ShopGrid
@onready var item_slots = [
	$MainContainer/ShopBackground/ShopGrid/Item1,
	$MainContainer/ShopBackground/ShopGrid/Item2,
	$MainContainer/ShopBackground/ShopGrid/Item3
]
@onready var item_description = $MainContainer/DescriptionBackground/DescriptionContainer/ItemDescription
@onready var buy_button = $MainContainer/DescriptionBackground/DescriptionContainer/BuyButton
@onready var currency_label = $MainContainer/ShopBackground/Currency
@onready var exit_button = $MainContainer/ExitButton

var shop_items = []  # Items currently in the shop
var selected_item = null  # Selected item for purchasing

var item_icons = {
	"Bubble Booster": preload("res://other/bubble_booster.png"),
	"Oxygen Tank": preload("res://other/oxygen_tank.jpg"),
	"Dice Modifier": preload("res://other/dice_modifier.png"),
	"Deep Diver Kit": preload("res://other/Screenshot 2024-05-03 123359-orig.png"),
	"Shield Bubble": preload("res://other/icon.svg")
}

var item_descriptions = {
	"Bubble Booster": "Increases oxygen efficiency, letting you go deeper.",
	"Oxygen Tank": "Fully restores your oxygen supply.",
	"Dice Modifier": "Allows you to reroll your dice once per level.",
	"Deep Diver Kit": "Provides a temporary depth boost.",
	"Shield Bubble": "Protects you from hazards for one level."
}

func _ready():

	generate_shop()
	update_ui()

	buy_button.hide()
	exit_button.pressed.connect(exit_shop)

# **Generate shop items using inventory system**
func generate_shop():
	shop_items = Inventory.get_random_items(3)

	for i in range(3):
		if i < shop_items.size():
			var item = shop_items[i]
			item_slots[i].texture_normal = item_icons[item["name"]]
			item_slots[i].pressed.connect(func(): select_item(item))

# **Update currency UI**
func update_ui():
	currency_label.text = "$" + str(Inventory.currency)

# **Handle item selection**
func select_item(item):
	selected_item = item
	item_description.text = item_descriptions[item["name"]]
	buy_button.show()
	buy_button.pressed.connect(buy_selected_item)

# **Handle purchasing**
func buy_selected_item():
	if selected_item and Inventory.currency >= selected_item["price"]:
		Inventory.subtract_currency(selected_item["price"])
		Inventory.add_item(selected_item["name"], 1)
		update_ui()
		print("Bought: " + selected_item["name"])
	else:
		print("Not enough money!")

# **Exit shop and return to main game**
func exit_shop():
	print("exiting")
	#GameManager.start_next_level()
	get_tree().change_scene_to_file("res://scenes/MainScene.tscn")
