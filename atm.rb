# ATM Project
# Author: Matthew Beebe
# Date: 11/28/2016

#---------------------BACK END-----------------------
# FILE CREATION / UPLOAD
require 'find'   #using 'find' class

accts_file = "temp"  #Set up temp names
trans_file = "temp"  

#Search directory for program's txt files
Find.find('..') do |path| 
   if (path.include?('accounts.txt') == true)
   		accts_file = path
   end
   if (path.include?('transactions.txt') == true)
   		trans_file = path
   end
end

#If these files dont exist, create them
if accts_file == "temp"
	File.new("accounts.txt", "w")
end
if trans_file == "temp"
	File.new("transactions.txt", "w")
end

#Create default instance of myAccount{} and trans[]
myAccount = {"Checking" => 0, "Savings" => 0}
trans = []

saved = ""
transSav = ""

#In each file, find contents and populate strings above
IO.foreach('accounts.txt') do |key|
	saved = key
end
IO.foreach('transactions.txt') do |key|
	transSav = key
end

#Clean strings to be sorted into {} or []
savedArray = saved.gsub('", ', "~").gsub('], [', "~").gsub(/[\[\]"]/, "").split("~")
transArr = transSav.gsub(/[\[\]" ]/, "").split(",")

#Populate Hash
n = 0
a = savedArray.size - 1
while n < a
	myAccount[savedArray[n]] = savedArray[n+1].to_i
	n += 2
end
#Populate Array
trans = transArr

# END FILE CREATE / UPLOAD

#METHODS

def viewAcct(bank)
	print "Total in Bank: $"
	vals = bank.values.to_a
	vals = vals.inject(0){|sum,x| sum+x}  #add all values together
	puts '%.2f' % vals #Display sum of all accounts and format
	puts ""
	keys = bank.keys.to_a 
	values = bank.values.to_a
	for n in 0..(keys.size-1) #Display each key with each value
		puts keys[n] + ": $" + '%.2f' % values[n]
	end
end

def deposit(arr, bank, acct, amt)
	if bank.key?(acct) == true   #If account exists
		bank[acct] += amt   #Increment amount
		puts ""
		puts "[Successfully added $#{'%.2f' % amt} to #{acct}]"
		arr.push(acct)   #Push to transaction history
		arr.push(amt)
	else
		puts ""   #Throw error if account doesnt exist
		puts "[You do not have an account named #{acct}]"
	end
end

def withdraw(arr, bank, acct, amt)
	if bank.key?(acct) == true   #Check for account
		if bank[acct] > amt   #Check available funds
			bank[acct] -= amt   #Decrement
			puts "[Withdrawing $#{'%.2f' % amt} from #{acct}]"
			neg = 0 - amt   #Push to Transaction History
			arr.push(acct)
			arr.push(neg)
		else
			puts ""   #Throw Error if non-sufficient funds
			puts "[You do not have $#{'%.2f' % amt} in #{acct} to Withdraw]"
		end
	else
		puts ""   #throw error if account doesnt exist
		puts "[#{acct} is not a valid account name]"
	end
end

def transfer(bank, acct, to_acct, amt)
	if (bank.key?(acct) == true) && (bank.key?(to_acct) == true)
		if bank[acct] > amt   #Check for both accounts
			bank[acct] -= amt   #Check for sufficient funds
			bank[to_acct] += amt  # (-) one account, (+) the other
			puts ""
			puts "[Successfully transferred $#{'%.2f'%amt} from #{acct} to #{to_acct}]"
		else
			puts ""   #Error if not enough funds
			puts "[#{acct} has less than $#{'%.2f'%amt} - cannot transfer]"
		end
	else
		puts ""   #Error if accounts dont exist
		puts "[Could not transfer between unknown Accounts]"
	end
end

def addAcct(bank, n)
	if bank.key?(n) == false   #Check if account exists
		bank[n] = 0  #if not, create new
		puts ""
		puts "[#{n} created as a new Account]"
	else   #Error if account exists
		puts "[#{n} already exists]"
	end
end

def viewTrans(arr)
	i = 0
	n = arr.size-1
	until i >= n   #Format each transaction to one line
		puts arr[i] + " ... $" + ('%.2f'%arr[i+1]).to_s
		i += 2
	end
end

#---------------------FRONT END----------------------
puts ""
puts     "=========[ Welcome to the Beebe ATM ]========="
	puts ""
	puts "--MENU---------------------------------------"
	puts "        [1] Check Accounts"
	puts "        [2] Deposit Money"
	puts "        [3] Make a Withdrawal"
	puts "        [4] Transfer Between Accounts"
	puts "        [5] Create a New Account"
	puts "        [6] Transaction History"
	puts "        [7] Exit"
	puts "---------------------------------------------"
	displaySub = false   #<--So that the menu doesn't appear 
while true				 #right below the first screen
	if displaySub == true
	puts "== MENU ==============================================================================="
	puts " [1]Accts, [2]Deposit, [3]Withdrawal, [4]Transfer, [5]NewAcct, [6]Transactions [7]Exit"
	puts "======================================================================================="
	end

	print "Selection: "
	selec = gets.chomp.to_i
	puts ""
	case selec
		when 1 			
			puts "------------------------------------------ ACCOUNT BALANCES --"
			viewAcct(myAccount)
			puts ""

		when 2 
			puts "-------------------------------------------- MAKE A DEPOSIT --"
			print "Account: "
			acct = gets.chomp.capitalize
			print "Amount: $"
			amt = gets.chomp.to_f
			deposit(trans, myAccount, acct, amt)
			puts ""

		when 3 
			puts "----------------------------------------- MAKE A WITHDRAWAL --"
			print "Account: "
			acct = gets.chomp.capitalize
			print "Amount: $"
			amt = gets.chomp.to_f
			withdraw(trans, myAccount, acct, amt)
			puts ""

		when 4
			puts "------------------------------------------- MAKE A TRANSFER --"
			print "Transfer from: "
			from = gets.chomp.capitalize
			print "To: "
			to = gets.chomp.capitalize
			print "Transfer Amount: $"
			amt = gets.chomp.to_f
			transfer(myAccount, from, to, amt)
			puts""

		when 5
			puts "---------------------------------------- CREATE NEW ACCOUNT --"
			print "New Account Name: "
			newAcct = gets.chomp.capitalize
			addAcct(myAccount, newAcct)
			puts ""

		when 6
			puts "---------------------------------------- TRANSACTION HISTORY --"
			viewTrans(trans)
			puts ""
		when 7 # Quit Program and save accounts
			#Save Current Accounts as a set
			account_a = myAccount.to_a
			filename = 'accounts.txt'
			IO.write(filename, account_a)
			IO.write('transactions.txt', trans)
			puts ""
			puts "Thank you for choosing Beebe ATMs"
			break
	end
	displaySub = true
end
