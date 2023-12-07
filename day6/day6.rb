$day = 6
$file = 'real.txt'
$lines = File.readlines("/Users/jeff/Projects/advent/day#{$day}/#{$file}")

times = $lines[0].scan(/\d+/).map &:to_i
distances = $lines[1].scan(/\d+/).map &:to_i

class Race
	def initialize time, distance
		@time = time
		@distance = distance
	end
	
	# D = T*t - t^2
	
	def distance(t) = (@time * t) - (t * t)
	
	# slow solution -- just try them all
	def distances
		(1...@time).filter {|t| distance(t) if distance(t) > @distance}
	end
end

part1 = times.zip(distances).map do |t, d|
	Race.new(t, d).distances.length
end

# part 1
p part1.reduce :*

# part 2
p Race.new(times.join.to_i, distances.join.to_i).distances.length