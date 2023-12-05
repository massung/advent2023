$day = 2
$file = 'real.txt'
$lines = File.readlines("/Users/jeff/Projects/advent/day#{$day}/#{$file}")

class Game
	def initialize(line)
		m = line.match(/Game (\d+): (.*)/)
		@id = m[1].to_i
		@draws = m[2].split(';').map do |draw|
			blocks = {'red' => 0, 'blue' => 0, 'green' => 0}
		
			# figure out how many of each color
			draw.split(',').each do |s|
				m = s.match(/(\d+) (red|green|blue)/)
				blocks[m[2]] = m[1].to_i
			end
		
			blocks
		end
	end
	
	def id = @id
	
	def possible?(limit)
		@draws.all? do |blocks|
			blocks.all? do |color, n|
				limit[color] >= n
			end
		end
	end
	
	def power
		max = {'red' => 1, 'green' => 1, 'blue' => 1}
		
		@draws.each do |blocks|
			max['red'] = [blocks['red'], max['red']].max
			max['green'] = [blocks['green'], max['green']].max
			max['blue'] = [blocks['blue'], max['blue']].max
		end
		
		return max['red'] * max['green'] * max['blue']
	end
end

part1 = $lines.sum do |line|
	game = Game.new(line)	
	game.possible?({'red' => 12, 'green' => 13, 'blue' => 14}) ? game.id : 0
end

part2 = $lines.sum do |line|
	Game.new(line).power
end

puts part1
puts part2
