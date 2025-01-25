extends Node

var inventory

var all_items = {
	"Bubble Booster": {"price": 10, "probability": 0.5},
	"Oxygen Tank": {"price": 20, "probability": 0.3},
	"Dice Modifier": {"price": 15, "probability": 0.2},
	"Deep Diver Kit": {"price": 50, "probability": 0.1},
	"Shield Bubble": {"price": 25, "probability": 0.4}
}

var shop_items = {}

func generate_shop():
	shop_items.clear()
	var item_pool = all_items.keys()
	
	while shop_items.size() < 3:
		var random_item = item_pool[randi() % item_pool.size()]
		var item_data = all_items[random_item]
		
		if randf() <= item_data["probability"]:
			shop_items[random_item] = item_data
	
	print_shop()
	
func buy_item(item_name: String):
	if item_name in shop_items:
		var cost = shop_items[item_name]["price"]
		
		if inventory.subtract_currency(cost):
			inventory.add_item(item_name, 1)
			print("Bought: " + item_name)
		else:
			print("You broke!!! Can't afford: " + item_name)
	else: print("Item not found in shop")
	
func print_shop():
	print("\n--- Shop Items ---")
	for item in shop_items.keys():
		print(item + " $" + str(shop_items[item]["price"]))
	print("------------------\n")

func _ready():
	inventory = get_node("/root/Main/Inventory")
	
	print("Generating Shop...")
	generate_shop()
	
	buy_item("Bubble Booster")
	buy_item("Deep Diver Kit")
	buy_item("Oxygen Tank")
	
	print("\nRemaining Money: $" + str(inventory.currency))
	inventory.print_inventory()
