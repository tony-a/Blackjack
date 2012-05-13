require './Hand'

class Player
	attr_accessor :total_money, :hands
	attr_reader :name
	def initialize(name)
		@name = name
		@total_money = 20
		@hands = nil  #eventually will be a list of hands, this will allow for multiple splits
	end
	
	def hit(hand, deck)
		card = deck.next_card
		hand.cards.push(card)
		hand.busted?
		hand.display
	end
	
	def doubledown(hand, deck)
		old_bet = hand.bet
		puts "You can increase your bet by up to $#{[total_money-old_bet, old_bet].min}."
		print "How much would you like to add to your bet: "
		new_bet = gets.to_i
		
		while new_bet <= 0 or new_bet>old_bet or (new_bet+old_bet) > @total_money
			print "please enter an amount greater than $0 and less than $#{[total_money-old_bet, old_bet].min}: "
			new_bet = gets.to_i
		end
		
		self.hit(hand, deck)
		hand.bet = old_bet + new_bet
		hand.stand = true
		hand.busted?
		hand.display
	end
	
	def split(hand, deck)
		new_hand = Hand.new
		
		card = hand.cards.pop
		new_hand.cards<<card
		new_hand.bet = @hands[0].bet
		@hands<<(new_hand)
	end
	
end