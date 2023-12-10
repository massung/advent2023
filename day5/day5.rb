$lines = File.readlines("/Users/jeff/Projects/advent/day5/real.txt")

class Map
	def initialize(lines)
		name = lines[0].delete_suffix(" map:\n").split('-')
		
		# what map is this
		@from = name[0]
		@to = name[2]
		@src = []
		@dst = []
	
		# parse the source and destination ranges
		lines[1..]
			.take_while {|line| line.length > 1}
			.each do |line|
				dst, src, n = line.scan(/\d+/).map &:to_i
				
				# add the ranges
				@src << (src...src+n)
				@dst << (dst...dst+n)
			end
	end
	
	def length = @src.length + 2  # map name + empty space
	
	def from = @from
	def to = @to
	
	def map(n)
		i = @src.index do |src|
			src.include?(n)
		end
		
		# no mapping?
		return n unless i
		
		# map to destination
		@dst[i].first + (n - @src[i].first)
	end
	
	def map_range(r)
		mapped = []
		not_mapped = []
		
		overlapped = @src.filter_map.with_index do |src, i|
			o = overlap(r, src)
			
			if o
				first = @dst[i].first + o.first - src.first
				last = first + o.last - o.first
				
				# add the mapped region
				mapped << (first..last)
			end
			
			o
		end
		
		# sort the overlaps by start
		overlapped.sort_by! &:first
		
		# cut the overlaps from the range to get the non-overlapping ranges
		i = r.first
		
		overlapped.each do |m|
			if i < m.first
				not_mapped << (i..m.first-1)
			end
			
			# skip to the next possible range
			i = m.last + 1
		end
		
		# add the last range if leftover
		not_mapped << (i..r.last) if i <= r.last
		
		# return all the mapped ranges
		mapped + not_mapped
	end
end

def overlap(r1, r2)
	return [r1.first, r2.first].max..[r1.last, r2.last].min unless r1.last < r2.first || r1.first > r2.last
end

def seed_to_location(src, maps) 
	maps.reduce(src) {|n, map| map.map(n)}
end

def seed_ranges_to_location_ranges(ranges, maps)
	maps.reduce(ranges) {|r, map| map.overlaps(r)}
end

# parse the seeds
seeds = $lines[0].scan(/\d+/).map &:to_i
maps = []

# parse each map
i = 2
while i < $lines.length - 1
	maps << Map.new($lines[i..])
	i += maps.last.length
end

# map all seeds for part 1
part1 = seeds.map {|src| seed_to_location(src, maps)}.min
p part1


# seed ranges
seed_ranges = seeds.filter_map.with_index {|n, i| n..n+seeds[i+1]-1 unless i & 1 == 1}
ranges = maps.reduce(seed_ranges) do |ranges, map|
	p "#{map.from} = #{ranges}"
	ranges.flat_map {|r| map.map_range(r)}
end

part2 = ranges.map(&:first).min
p part2
