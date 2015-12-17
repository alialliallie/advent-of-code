def run
  i = solve(input)
  puts "Part 1 #{i[:happinesses].max}"
  i2 = solve(input + ["Allison would gain 0 happiness units by sitting next to Allison."])
  puts "Part 1 #{i2[:happinesses].max}"
end

def input(file = 'day13.input')
  File
  .readlines(file)
end

def solve(input)
  happiness = input.flat_map(&method(:parse))
    .each_with_object({}) do |e, a|
      a[[e[0], e[1]]] = e[2]
    end
  people = happiness.map {|p| p[0][0]}.uniq.sort
  happinesses = people.permutation.map do |c|
    seating = c + [c[0]]
    seating.each_cons(2).reduce(0) do |h, p|
      unless p.include? "Allison"
        h + happiness[p] + happiness[p.reverse]
      else
        h
      end
    end
  end
  {
    happiness: happiness,
    people: people,
    happinesses: happinesses
  }
end

def parse(line)
  m = line.match(/(\S+).+(lose|gain) (\d+).+ (\S+)\./)
  h = m[3].to_i
  [
    [m[1], m[4], m[2] == 'lose' ? -h : h]
  ]
end
