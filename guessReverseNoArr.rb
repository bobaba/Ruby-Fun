puts ""
puts "========[ The Guessing Machine ]========"
puts "  Choose one of the following:"
puts "     (1) 1-120 guessed in 7 tries"
puts "     (2) 1-1,000 guessed in 10 tries"
puts "     (3) 1-10,000 guessed in 14 tries"
puts ""

#According to User selection, set maxHigh and limit of guesses
maxHigh = 0
limit = 0
while maxHigh < 1
	print "I challenge you to: " 
	challenge = gets.chomp.to_i
	if challenge == 1
		maxHigh = 120
		limit = 7
	elsif challenge == 2
		maxHigh = 1000
		limit = 10
	elsif challenge == 3
		maxHigh = 10000
		limit = 14
	else
		#prevent error
		puts "Not a proper selection, please try again!"
	end
end

puts ""
puts "Choose a number between 1 and #{maxHigh} and I will guess it in #{limit} tries!"
puts "----------------------------------------------------------------------"
puts "                [press enter when you have your number]"


#Set Variables with Defaults
compGuess = 0
userReply = ""
start = gets.chomp
guessNum = 1
maxLow = 1

# Loop until max guesses
until guessNum > limit

	#call middle of array as next guess
	compGuess = maxLow + ((maxHigh - maxLow) / 2)

	#if number of guesses reaches the limit, output sure answer
	if (guessNum == limit )
		puts ""
		puts "...and #{limit}: Your number is #{compGuess}!"
		exit
	end

	# Guess questioning and reply
	puts ""
	puts "Guess #{guessNum}: is your number #{compGuess}?"
	print "My number is "
	userReply = gets.chomp.downcase
	
	# if 'higher', then max low is current guess plus one
	if userReply == "higher"
		maxLow = compGuess +1
		guessNum += 1
	#if 'lower', then max high is current guess minus one
	elsif userReply == "lower"
		maxHigh = compGuess -1
		guessNum += 1
	#if guessed correctly mid guessing
	elsif userReply == ("that one!" || "yes!")
		puts "I guessed your number in #{guessNum} tries!"
		guessNum = limit +1 #breaks out of loop - done
	#user error
	else
		puts "Please tell me if your number is 'higher' or 'lower'!"
	end

end