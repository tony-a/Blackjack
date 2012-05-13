class Card
	attr_accessor :rank, :suit, :value
	def initialize(rank, suit)
		@rank = rank
		@suit = suit
		@value = nil	
	end
	
	def value
		if ['J', 'Q', 'K'].include? @rank
			@value = 10
		elsif @rank != 'A'
			@value = @rank
		else
			@value = Ace
		end
	end
	
	def display
		return "#{@rank}-#{@suit}"
	end
	
end