def input(file = 'day9.input')
  File
    .readlines(file)
end

def solve(input)
  paths = input.flat_map(&method(:parse))
    .each_with_object({}) do |e, a|
      a[[e[0], e[1]]] = e[2]
    end
  cities = paths.map {|p| p[0][0]}.uniq.sort
  distances = cities.permutation.map do |c|
    c.each_cons(2).reduce(0) do |dist, p|
      dist + paths[p]
    end
  end
end

def parse(line)
  m = line.match(/(.+) to (.+) = (\d+)/)
  [
    [m[1], m[2], m[3].to_i],
    [m[2], m[1], m[3].to_i]
  ]
end
