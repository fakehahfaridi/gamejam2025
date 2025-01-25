extends Node

var inventory = {}
var currency = 50

func add_item(item_name: String, quantity: int = 1):
	if item_name in inventory:
		inventory[item_name] += quantity
	else:
		inventory[item_name] = quantity
		
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
