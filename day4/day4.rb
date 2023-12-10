$lines = File.readlines("/Users/jeff/Projects/advent/day4/real.txt")

class Card
	def initialize line
		have, winning = line.split('|')
		
		# parse card
		@have = have.scan(/\d+/).map &:to_i
		@winning = winning.scan(/\d+/).map &:to_i
		
		# extract the card number
		@id = @have.shift - 1
	end
	
	def matches
		@have.count {|i| @winning.include?(i)}
	end
	
	def score
		n = matches
		n > 0 ? 2 ** (n-1) : n
	end
	
	def id = @id
end

cards = $lines.map {|line| Card.new(line)}

part1 = cards.map(&:score).sum
part2 = 0

# find all the matches for each card
matches = cards.map &:matches
queue = cards.map &:id

while queue.length > 0
	i = queue.pop
	
	# tally
	part2 += 1
	
	# push back onto the queue
	(1..matches[i]).each do |j|
		queue << i+j
	end
end

p part1
p part2
