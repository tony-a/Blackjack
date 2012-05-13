require './card'

class Deck
	attr_reader :length
	def initialize
		@ranks = %w(ace 2 3 4 5 6 7 8 9 10 J Q K)
		@suits = %w(Spades Hearts Diamonds Clubs)
	
		@deck = [] 
		@ranks.each {|rank| @suits.each {|suit| @deck << Card.new(rank, suit)}}
	
		@length = 52
	end
		
	def next_card
		return @deck.pop
	end	
end