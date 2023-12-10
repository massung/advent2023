$lines = File.readlines("/Users/jeff/Projects/advent/day3/real.txt")

class Schematic
	def initialize(lines)
		@lines = lines.map! &:strip
		
		# find all the number positions
		@numbers = lines.flat_map.with_index do |line, y|
			line.to_enum(:scan, /\d+/)
				.map { [$~, y] }
		end
	end
	
	def part_symbol?(x, y)
		y >= 0 && x >= 0 && y < @lines.length && x < @lines[y].length && !"0123456789.".include?(@lines[y][x])
	end
	
	def adjacent?(m, y)
		i = m.offset(0)
		r = i[0]-1 .. i[1]
		
		b = r.any? do |x|
			part_symbol?(x, y) || part_symbol?(x, y-1) || part_symbol?(x, y+1)
		end
	end
	
	def adjacent_numbers
		rows = @lines.length
		
		@numbers
			.filter {|ns| self.adjacent?(*ns)}
			.map {|ns| ns[0].to_s.to_i}
	end
	
	def gears
		gears = []
		
		@lines.each_with_index do |line, y|
			line.chars.to_enum.with_index do |c, x|
				if c == '*'
					matches = @numbers.filter do |ns|
						xs = ns[0].offset(0)
						xr = xs[0]-1..xs[1]
						yr = ns[1]
						
						# are they adjacent?
						(y-1..y+1).include?(yr) && xr.include?(x)
					end
					
					if matches.length == 2
						gears << matches.map {|ns| ns[0].to_s.to_i}.reduce(:*)
					end
				end
			end
		end
		
		gears
	end
end

s = Schematic.new($lines)

part1 = s.adjacent_numbers.sum
part2 = s.gears.sum

p part2
