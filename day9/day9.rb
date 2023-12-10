$lines = File.readlines("/Users/jeff/Projects/advent/day9/real.txt")

def history(line) = line.scan(/-?\d+/).map &:to_i
def delta(h) = h[1..].map.with_index {|x, i| x - h[i]}

def deltas(h)
	ds = [h]
	
	while delta(h).any? {|i| i != 0}
		ds << (h = delta(h))
	end
	
	ds
end

def extrapolate(ds) = ds.reverse.reduce(0) {|x, h| h[-1] + x}
def extrapolate_backwards(ds) = ds.reverse.reduce(0) {|x, h| h[0] - x}

# part 1
p $lines.sum {|line| extrapolate(deltas(history(line)))}
p $lines.sum {|line| extrapolate_backwards(deltas(history(line)))}