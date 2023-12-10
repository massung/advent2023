$lines = File.readlines("/Users/jeff/Projects/advent/day6/real.txt")

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
		(1...@time).count {|t| distance(t) if distance(t) > @distance}
	end
	
	# fast solution: -t^2 + T*t - D = 0
	def distances_fast
		a = -1
		b = @time
		c = -@distance
		
		# radical
		r = b*b - 4*a*c
		
		# always 2 solutions due to the nature of the problem
		x1 = ((-b + Math.sqrt(r)) / 2*a).to_i + 1
		x2 = ((-b - Math.sqrt(r)) / 2*a).to_i
		
		x2 - x1 + 1
	end
end

part1 = times.zip(distances).map do |t, d|
	Race.new(t, d).distances_fast
end

# part 1
p part1.reduce :*

# part 2
p Race.new(times.join.to_i, distances.join.to_i).distances_fast
