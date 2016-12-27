# Build an Inventory program.

# Use a hash to store hard coded data
# When a user requests to see the inventory, display the contents of your hash (which is your inventory)
# Add an option to allow the user to add a completely new item to the inventory
# Add an option to allow the user to remove an item from the inventory

# Inventory will be Key: item, Value: amount in stock

# Find inventory lists
require 'find'

#Check to see if 'inventory.txt' exists. 
#   if not, add it to directory
txt_file_path = "temp"
Find.find('..') do |path| 
   if (path.include?('inventory.txt') == true)
   		txt_file_path = path
   	end
end
if txt_file_path == "temp"
	File.new("inventory.txt", "w")
end

inventory = {}

# Acquire any saved Inventory
saved = ""

IO.foreach('inventory.txt') do |key|
	saved = key
end
#Prepare array for clean hash
savedArray = saved.gsub('", ', "~").gsub('], [', "~").gsub(/[\[\]"]/, "").split("~")
#Populate Hash
n = 0
a = savedArray.size - 1
while n < a
	inventory[savedArray[n]] = savedArray[n+1].to_i
	n += 2
end


puts "===================================="
puts "|            Inventory             |"
puts "===================================="
puts "| '1' = View Inventory             |"
puts "| '2' = Add Item to Inventory      |"
puts "| '3' = Remove Item from Inventory |"
puts "| '4' = Sell an Item               |"
puts "| '5' = Quit                       |"
puts "===================================="
puts ""
selec = 0
running = true
while running == true
	puts "                    ------------------------------------------------"
	puts "                    | (1)View, (2)Add, (3)Remove, (4)Sell, (5)Quit |"
	print "                      Selection: "
	selec = gets.chomp
	i = selec.split(" << ")
	puts "                    ------------------------------------------------"
	if (selec.to_i == 1 || selec.capitalize == "View")
		puts "------------------------------------"
		puts "       Currently in Inventory       "
		puts "------------------------------------"
		puts inventory.to_a
		if inventory.size == 0
			puts ""
			puts "              [empty]"
			puts ""
		end
	elsif (selec.to_i == 2 || selec.capitalize == "Add")
		puts "------------------------------------"
		puts "        Add Item to Inventory       "
		puts "------------------------------------"
		print "Item to add: "
		newItem = gets.chomp.capitalize
		if inventory.key?(newItem) == true
			puts "This Item already exists!"
			print "How many more would you like to add to the stock? "
			addOn = gets.chomp.to_i
			inventory[newItem] = inventory[newItem] + addOn
			puts "There are now #{inventory[newItem]} #{newItem} in Stock"
		else
			print "Amount of item: "
			newAmt = gets.chomp.to_i
			inventory[newItem] = newAmt
			puts "      ----[ #{newAmt} #{newItem.capitalize} added! ]----"
		end
	elsif (selec.to_i == 3 || selec.capitalize == "Remove")
		puts "------------------------------------"
		puts "     Remove Item from Inventory     "
		puts "------------------------------------"
		print "Item to Remove: "
		removeThis = gets.chomp.capitalize
		if inventory.key?(removeThis) == false
			puts "Cannot remove an item that doesn't exist!"
		else
			inventory.delete(removeThis)
			puts "      ----[ #{removeThis} removed! ]----."
		end
	elsif (selec.to_i == 4 || selec.capitalize == "Sell")
		puts "------------------------------------"
		puts "            Sell an Item            "
		puts "------------------------------------"
		print "Item to Sell: "
		sellThis = gets.chomp.capitalize
		if inventory.key?(sellThis) == false
			puts "I'm Sorry... we do not have that in stock."
		else
			print "How many #{sellThis} would you like to sell? "
			sellAmount = gets.chomp.to_i
			if inventory[sellThis] >= sellAmount
				inventory[sellThis] = inventory[sellThis] - sellAmount
				puts ""
				puts "Successfully sold #{sellAmount} #{sellThis}. #{inventory[sellThis]} left in Stock."
			elsif inventory[sellThis] < sellAmount
				puts "You do not have enough in stock!"
				puts "Currently in stock: #{inventory[sellThis]}"
			end
		end
	elsif (selec.to_i == 5 || selec.capitalize == "Quit")
		puts ""
		puts "Would you like to save your Inventory? (Y/N)"
		saveIt = gets.chomp.capitalize
		if saveIt == "Y"
			#Save Current Inventory as a set
			inventory_a = inventory.to_a
			filename = 'inventory.txt'
			IO.write(filename, inventory_a)
			puts ""
			puts "[Inventory Saved]"
			running = false
		elsif saveIt == "N"
			puts ""
			puts "[Nothing has been Saved]"
			running = false
		else
			puts "That is an Invalid option. 'Y' or 'N'"
		end
	# Add functionality to move faster
	elsif (selec.downcase == "add << #{i[1]} << #{i[2]}")
		if inventory.include?(i[1].capitalize)
			inventory[i[1].capitalize] = inventory[i[1].capitalize] + i[2].to_i
			puts "                             ----[ Added #{i[2]} to #{i[1].capitalize}! ]----"
		else
			inventory[i[1].capitalize] = i[2].to_i
			puts "                              ----[ Added #{i[2]} #{i[1].capitalize}! ]----"
		end
	elsif (selec.downcase == "remove << #{i[1]}")
		if inventory.include?(i[1].capitalize)
			inventory.delete(i[1].capitalize)
			puts "                               ----[ #{i[1].capitalize} removed ]----"
		else
			puts "                                  does not exist"
		end
	elsif (selec.downcase == "sell << #{i[1]} << #{i[2]}")
		if inventory[i[1].capitalize] >= i[2].to_i
				inventory[i[1].capitalize] = inventory[i[1].capitalize] - i[2].to_i
				puts "                              ----[ #{i[2]} #{i[1].capitalize} Sold! ]----"
				puts "                                **[ #{inventory[i[1].capitalize]} #{i[1].capitalize} Left ]**"
		else
			puts "                               ----[ Not enough in Stock! ]----"
		end
	else
		puts "Invalid Selection! Try Again..."
	end
end







