$day = 1
$file = 'real.txt'
$lines = File.readlines("/Users/jeff/Projects/advent/day#{$day}/#{$file}")
$words = ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']

def part1(line)
	n = line.chars.select {|c| c =~ /\d/}
	"#{n.first}#{n.last}".to_i
end

def digit(s)
	$words.index(s) || s
end

def part2(line)
	r = /zero|one|two|three|four|five|six|seven|eight|nine|\d/
	m = line.match(r)
	
	# work backwards finding the last match
	for i in (line.length - 1).downto(0) do
		n = line[i..].match(r)
		
		if n != nil then
			break
		end
	end
	
	"#{digit(m.to_s)}#{digit(n.to_s)}".to_i
end

puts $lines.sum {|line| part1(line)}
puts $lines.sum {|line| part2(line)}
