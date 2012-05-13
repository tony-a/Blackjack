require './Hand'

class Dealer
	attr_accessor :hand, :bust

	def initialize
		@hand = nil
	end
	
	def hit(deck)
		result = @hand.display
		
		card = deck.next_card
		@hand.cards.push(card)
		
		print "Dealer's hand: "

		if @hand.cards.length != 2
			puts @hand.display
			puts
		else
			2.times{result.chop!}
			print result
			puts ", [FACE-DOWN CARD])"
			puts
		end
		
		@hand.busted?
	end
	
	def complete_hand(deck)
		sum = @hand.evaluate
		while sum < 17 or (sum <= 17 and @hand.soft17)	
			print "Dealer will hit. "
			self.hit(deck)
			sum = @hand.evaluate
		end
	end
	
end
