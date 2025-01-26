extends Node

var inventory = {}
var currency = 50000

var all_items = {
	"Bubble Booster": {"price": 10, "probability": 0.5},
	"Oxygen Tank": {"price": 20, "probability": 0.3},
	"Dice Modifier": {"price": 15, "probability": 0.2},
	"Deep Diver Kit": {"price": 50, "probability": 0.1},
	"Shield Bubble": {"price": 25, "probability": 0.4}
}

func get_random_items(amount: int) -> Array:
	var selected_items = []
	var item_pool = all_items.keys()

	while selected_items.size() < amount:
		var random_item = item_pool[randi() % item_pool.size()]
		var item_data = all_items[random_item]

		# Probability check
		if randf() <= item_data["probability"]:
			selected_items.append({"name": random_item, "price": item_data["price"]})

	return selected_items

func add_item(item_name: String, quantity: int = 1):
	if item_name in inventory:
		inventory[item_name] += quantity
		print_inventory()
	else:
		inventory[item_name] = quantity
		print_inventory()
		
func remove_item(item_name: String, quantity: int = 1):
	if item_name in inventory:
		inventory[item_name] -= quantity
		if inventory[item_name] <= 0:
			#  remove instance from inventory if quantity is 0
			inventory.erase(item_name)

func add_currency(amount: int):
	currency += amount
	print("Earned $" + str(amount) + "! New balance: $" + str(currency))

func subtract_currency(amount: int) -> bool:
	if currency >= amount:
		currency -= amount
		print("Spent $" + str(amount) + ". New balance: $" + str(currency))
		return true
	else:
		print("You broke!!! Current balance: $" + str(currency))
		return false

func print_inventory():
	print("\n--- Inventory ---")
	for item in inventory.keys():
		print(item + ": " + str(inventory[item]))
	print("Currency: $" + str(currency))
	print("----------------\n")
