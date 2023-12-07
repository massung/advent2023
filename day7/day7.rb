$day = 7
$file = 'real.txt'
$lines = File.readlines("/Users/jeff/Projects/advent/day#{$day}/#{$file}")

$all_cards = "..23456789TJQKA"

class Hand
	def initialize line, wilds
		@cards, bet = line.split(/\s+/)
		
		# parse the bet and cards
		@bet = bet.to_i
		@pips = @cards.chars.map {|c| $all_cards.index(c)}
		@buckets = [0] * $all_cards.length
		@wilds = 0
		
		# count and rescore wild cards
		if wilds
			@wilds = @pips.count(11)
			
			# change the score of the wild cards
			@pips.map! {|pip| (pip == 11) ? 1 : pip}
		end
		
		# bucket card values
		@pips.each do |c|
			@buckets[c] += 1 if c > 1  # don't bucket wildcards
		end
		
		# special case: all cards are wild, turn them into all aces
		if @wilds == 5
			@buckets[14] = 5
			@wilds = 0
		end
		
		# apply wilds to buckets with the most cards
		@buckets
			.map
			.with_index {|n,i| [n,i]}
			.sort_by {|b| -b[0]}
			.each do |b|
				@buckets[b[1]] += @wilds if @wilds > 0
				@wilds -= @buckets[b[1]] - b[0]
			end
		
		# count buckets, highest card value first
		@pairs = @buckets.filter_map.with_index {|b, i| i if b == 2}.sort!.reverse!
		@sets = @buckets.filter_map.with_index {|b, i| i if b == 3}.sort!.reverse!
		@quads = @buckets.filter_map.with_index {|b, i| i if b == 4}.sort!.reverse!
		@fives = @buckets.filter_map.with_index {|b, i| i if b == 5}.sort!.reverse!
		
		# determine the high cards NOT in a pair, set, ...
		@high_cards = @pips.sort.reverse.filter do |c|
			!(@pairs.include?(c) || @sets.include?(c) || @quads.include?(c) || @fives.include?(c))
		end
		
		# 5s, 4s, 3s, 2s, 3s, 2s, 2s, 2s, high cards...
		@score = [0, 0, 0, 0, 0, 0, 0, 0]
		
		# in order of hand values
		@score[0..0] = @fives         if @fives.length == 1
		@score[1..1] = @quads         if @quads.length == 1
		@score[2..3] = @sets + @pairs if @sets.length == 1 && @pairs.length == 1
		@score[4..4] = @sets          if @sets.length == 1
		@score[5..6] = @pairs         if @pairs.length == 2
		@score[7..7] = @pairs         if @pairs.length == 1
		
		# add the high cards to break ties
		@score += @high_cards
		
		# fill out the rest of the array for comparisons
		while @score.length < 13
			@score << 0
		end
		
		# "simple" score
		@simple_score = [0] + @pips
		
		case
		when @fives.length == 1; @simple_score[0] = 6
		when @quads.length == 1; @simple_score[0] = 5
		when @sets.length == 1 && @pairs.length == 1; @simple_score[0] = 4
		when @sets.length == 1; @simple_score[0] = 3
		when @pairs.length == 2; @simple_score[0] = 2
		when @pairs.length == 1; @simple_score[0] = 1
		end
	end
	
	def cards = @cards
	def bet = @bet
	
	# calculate a single score value using (real poker!)
	def score = @score.map.with_index {|x,i| x*(16**(16-i))}.sum
	
	# "simple" score total
	def simple_score = @simple_score.map.with_index {|x,i| x*(16**(16-i))}.sum
		
	# winnings - bet * rank
	def winnings(rank) = rank * @bet
	
	def to_s = "#{@cards} (#{@simple_score}) == #{simple_score} (#{@bet})"
end

# parse and score hands
hands = $lines.map {|line| Hand.new(line, false)}
hands.sort_by! &:simple_score

# part 1
puts hands.map.with_index {|h,i| h.winnings(i+1)}.sum

# parse and score wildcard hands
hands = $lines.map {|line| Hand.new(line, true)}
hands.sort_by! &:simple_score

hands.each do |h|
	puts h.to_s
end

# part 2
puts hands.map.with_index {|h,i| h.winnings(i+1)}.sum
