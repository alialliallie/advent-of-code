def solve(x = 40)
  input = File.read('day10.input').chars.map(&:to_i)
  last = input
  x.times do |i|
    print "#{i} "
    last = generate(last)
  end
  last.join
end

def generate(seq)
  seq
    .slice_when { |l, r| l != r }
    .flat_map { |c| [c.length, c[0]] }
end
