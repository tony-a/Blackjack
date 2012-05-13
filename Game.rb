require './Player'
require './Shoe'
require './Dealer'
require './Hand'

class Game
	attr_accessor :end_game, :game_status, :players
	
	def initialize
		@end_game = false
		@dealer = Dealer.new
		@players = []
		@deck = Shoe.new(4) #creates a shoe with 4 decks
	end
	
	def game_status
		puts "================================================"
		delete_plyrs = [] # a list to track all players with $0. then delete them
		for plyr in @players
			if plyr.total_money == 0
				delete_plyrs << plyr
				puts "#{plyr.name}, looks like you're all out of money, thanks for playing!"
			else
				print "#{plyr.name}, would you like to keep playing (y/n):  "
				status = gets.chomp!
				while !['yes', 'no', 'y', 'n'].include? status
					print "please enter yes or no: "
					status = gets.chomp!
				end
				
				if status == 'no' or status == 'n'
					puts "Thank you for playing!"
					delete_plyrs << plyr			
				end
			end
		end
		@players = @players - delete_plyrs
		
		if @players.length == 0
			puts
			puts "looks like there are no more players"
			@end_game = true
		end	
	end
	
	def set_table
		puts "Welcome to Blackjack with ruby!"
		print "how many players would you like to play with: "
		num_players = gets.to_i
		while num_players == 0
			print "please enter a valid number: "
			num_players = gets.to_i
		end
		
		for plyr in 1..num_players
			print "please enter name of player number #{plyr}: "
			name = gets.chop!
			new_player = Player.new(name)
			new_player.hands = [Hand.new]
			@players << new_player
		end
		@dealer.hand = Hand.new
		puts
	end
	
	def initial_hand
		for plyr in @players
			plyr.hands = [Hand.new]
			print "#{plyr.name}, you have $#{plyr.total_money}. Please enter bet now: "
			bet = gets.to_i
			while bet>plyr.total_money or bet <= 0
				print "Please enter an amount greater than 0 and less than #{plyr.total_money}: "
				bet = gets.to_i
			end
			plyr.hands[0].bet = bet
			puts
		end
		@dealer.hand = Hand.new
		
		puts "===================LET'S PLAY==================="
		
		2.times {
			for plyr in @players
				puts "#{plyr.name}'s hand so far: " + plyr.hit(plyr.hands[0], @deck)
			end
			@dealer.hit(@deck)
			puts
				}
	end
	
	
	def run_game
		num_hands = 0 # these two values will be used to determine if everybody busted or not, and whether the dealer should play
		num_busts = 0
		for plyr in @players
			for hand in plyr.hands  #cycles through all hands of a given player, in case they have a split hand
				sum = hand.evaluate
				print "#{plyr.name}'s hand: " + hand.display, " for a value of #{sum} \n"
				while !hand.stand and !hand.bust
				
					print "what would you like to do (hit, stand, split or doubledown): "
					move = gets.chomp!
					while !['hit', 'stand', 'split', 'doubledown'].include? move
						print "please choose one of the following (hit, stand, split or doubledown): "
						move = gets.chomp!
					end
					puts
					
					if move == 'hit'
						puts "#{plyr.name}'s hand so far: " + plyr.hit(hand, @deck) + " for a value of #{hand.evaluate} \n"
					
					elsif move == 'doubledown'
						if hand.cards.length != 2
							puts "You must have two cards only to double down."
							next
						elsif hand.bet == plyr.total_money
							puts "You don't have enough money to double-down"
						else							
							puts 'Now your hand is: ' + plyr.doubledown(hand, @deck)
							puts
						end
					
					elsif move == 'stand'
						hand.stand = true
					
					else
						if hand.cards.length != 2
							puts "You must have two cards only to split."
							next
						elsif hand.cards[0].rank != hand.cards[1].rank
							puts "Sorry, these aren't matching card. you can't split"
							next
						elsif hand.bet.to_i*(plyr.hands.length + 1) > plyr.total_money
							puts "Sorry you don't have enough money to split"
							next
						else			
							plyr.split(hand, @deck)
							print "okay, we'll split. Here's the first card: " + hand.display + "\n"
							next
						end
					end	
					
					if hand.busted?
						puts "Sorry, you bust!"
						plyr.total_money -= hand.bet
						puts "You now have $#{plyr.total_money}!"
						num_busts += 1
					end
					
				end
				num_hands += 1
			end
			puts "================================================"
		end
		
		
		#check if there are any remaining hands that didn't bust
		if num_hands != num_busts
	
			puts "Dealer's turn now:"
			print "Dealer's current hand is: "
			puts @dealer.hand.display 
			@dealer.complete_hand(@deck)
			puts
			
			self.reconcile
		end
			
	end
	
	def reconcile #I believe this was the name you suggested?? 
		if @dealer.hand.bust
			puts "Dealer has busted, everybody wins!"
			for plyr in @players
				for hand in plyr.hands
					if !hand.bust	
						plyr.total_money += hand.bet * 2
						puts "#{plyr.name} now has $#{plyr.total_money}!"
					end
				end
			end
		else
		
			dealer_sum = @dealer.hand.evaluate

			for plyr in @players
				for hand in plyr.hands
					if !hand.bust
						player_sum = hand.evaluate
						puts "#{plyr.name} got #{player_sum} vs. dealer's #{dealer_sum}"
					
						if dealer_sum.to_i > player_sum.to_i
							puts "Sorry #{plyr.name}, you lose"
							plyr.total_money -= hand.bet
					
						elsif dealer_sum.to_i < player_sum.to_i
							puts "CONGRATULATIONS #{plyr.name}, you won!"
							plyr.total_money += hand.bet
					
						else
							puts "#{plyr.name}, you didn't lose anything. It's a draw!"
						end
						puts "You now have $#{plyr.total_money}!"
					end
				end
				puts
			end
		end
	end
end

game = Game.new 
game.set_table
while !game.end_game
	game.initial_hand
	game.run_game
	game.game_status
end 

