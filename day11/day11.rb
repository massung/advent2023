$lines = File.readlines("/Users/jeff/Projects/advent/day11/real.txt")

$W = $lines[0].length
$H = $lines.length

$expanded_rows = $lines.filter_map.with_index do |line, row|
	row if line.strip.chars.all?('.')
end

$expanded_cols = (0...$W).filter_map do |col|
	col if $lines.all? {|line| line[col] == '.'}
end

$galaxies = $lines.flat_map.with_index do |line, row|
	line.chars.filter_map.with_index {|c, col| [row, col] if c == '#'}
end

# expand the positions of galaxies
def expanded_galaxies(f)
	$galaxies.map do |g|
		[
			g[0] + (f-1) * $expanded_rows.count {|r| r < g[0]},
			g[1] + (f-1) * $expanded_cols.count {|c| c < g[1]},
		]
	end
end

def distance(g1, g2)
	(g1[0] - g2[0]).abs + (g1[1] - g2[1]).abs
end

$pairs = (0...$galaxies.length).flat_map do |i|
	(i+1...$galaxies.length).map {|j| [i, j]}
end

$g_part1 = expanded_galaxies(2)
$g_part2 = expanded_galaxies(1_000_000)

part1 = $pairs.sum do |i, j|
	distance($g_part1[i], $g_part1[j])
end

part2 = $pairs.sum do |i, j|
	distance($g_part2[i], $g_part2[j])
end

p part1
p part2