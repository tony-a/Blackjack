require './Shoe'

class Hand
	attr_reader :total_hand, :soft17
	attr_accessor :cards, :stand, :bet, :bust

	def initialize
		@stand = false
		@bust = false
		@bet = nil
		@cards = []
		@stand = false
		@soft17 = false #this is to be used by the dealer, so that he can hit on a soft 17
	end

	def display
		result = '('
		for card in @cards
			result += card.display 
			result += ', ' 
		end
		2.times {result.chop!}
		result += ')'
		return result 
	end

	
	def evaluate #returns an int
	    num_a = 0 #number of aces in a hand
        total_hand = 0
                            
        for card in cards
	        if card.value == 'ace'
				num_a += 1 
			else
				total_hand += card.value.to_i
            end 
        end

        for ace in 0...num_a
        	if total_hand <= 10
        		@soft17 = true
        		total_hand += 11
        	else
        		total_hand += 1 
        	end
        end
        return total_hand
    end
    
    def busted? 
    	hand_sum = self.evaluate
    	if hand_sum > 21
    		@bust = true
    	else
    		@bust = false
    	end
    end

end