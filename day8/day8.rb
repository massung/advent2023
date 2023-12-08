$lines = File.readlines("/Users/jeff/Projects/advent/day8/real.txt")

# instructions line
$instructions = $lines[0].strip.chars

def parse_node(line)
	node, l, r = line.scan(/[A-Z]{3}/)	
	[node, [l, r]]
end

# graph nodes
$graph = $lines[2..].map {|line| parse_node(line)}.to_h

def part1
	node = 'AAA'
	step = 0
	
	while node != 'ZZZ'
		l, r = $graph[node]
	
		case $instructions[step % $instructions.length]
		when "L"; node = l
		when "R"; node = r
		end
		
		step += 1
	end
	
	step
end

puts part1


$starts = $graph.keys.filter {|k| k.end_with?('A')}

def part2
	cache = {}
	
	# Each of the start nodes likely ends up in a loop, so we need save off - for each
	# node and instruction pair - how many steps it takes to get to an end node in the
	# cache. Once every node is at the end - or a cached position - we can just compute
	# how long it will take for them all to loop around together.
	
	$starts.each do |n|
		history = []
		step = 0
		
		while true
			ix = step % $instructions.length
			
			# already cached solution
			if cache.has_key?([n, ix])
				z, j = cache[[n, ix]]
				
				# flush the history
				history.reverse.each.with_index do |k, i|
					cache[k] = [z, i + j + 1]
				end
				
				# loop discovered
				break
			end
			
			# at the end? cache the history
			if n.end_with?('Z')
				history.reverse.each.with_index do |k, i|
					cache[k] = [n, i + 1]
				end
				
				# reset the history
				history = []
			end
			
			history << [n, ix]
			
			# lookup the next move
			l, r = $graph[n]
		
			# move
			case $instructions[ix]
			when "L"; n = l
			when "R"; n = r
			end
			
			# advance
			step += 1
		end
	end
	
	# Use the cache to advance really fast. When all nodes are at the same number of
	# steps total, then we've completed.
	
	nodes = $starts.clone
	
	# find the base steps and then steps per cycle for each node
	steps = $starts.map do |n|
		base_steps = 0
		
		# first step
		z, k = cache[[n, 0]]
		
		# go until there's a cycle (returning to same zed)
		while z != n
			base_steps += k
			n = z
			
			# keep going
			z, k = cache[[n, base_steps % $instructions.length]]
		end
		
		# HACK! Turns out the input doesn't have a base -> cycle; each start is a
		#       complete cycle on its own, so there's no tackling that issue.
		
		# return the base steps and cycle steps
		k
	end
	
	# find the LCM of all the starting nodes
	steps.reduce {|a, b| a.lcm(b)}
end

puts part2