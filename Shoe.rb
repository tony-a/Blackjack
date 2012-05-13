require './Deck'

class Shoe
	attr_reader :length
	
	def initialize(num)
		@length = num*52 
		
		@master_deck = []
		for i in 1..num
			new_deck = Deck.new
			for card in 1..new_deck.length
				@master_deck.push(new_deck.next_card)
			end
		end
		@master_deck.replace @master_deck.sort_by {rand}
	end


	def next_card
		return @master_deck.pop
	end	
end