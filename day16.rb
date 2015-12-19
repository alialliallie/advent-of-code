def input
  File.readlines('day16.input')
    .map(&method(:make_aunt))
    .reduce({}) { |a, e| a.merge(e) }
end

def solve(input)
  input.find_all do |aunt, attributes|
    attributes.keys.all? do |k|
      case k
      when 'cats', 'trees'
         attributes[k] > sample[k]
      when 'pomeranians', 'goldfish'
         attributes[k] < sample[k]
      else
        sample[k] == attributes[k]
      end
    end
  end
end

def sample
  {
    'children' => 3,
    'cats' => 7,
    'samoyeds' => 2,
    'pomeranians' => 3,
    'akitas' => 0,
    'vizslas' => 0,
    'goldfish' => 5,
    'trees' => 3,
    'cars' => 2,
    'perfumes' => 1
  }
end

def make_aunt(line)
  id, sig = line.split(': ', 2)
  {
    id => Hash[
      sig.split(', ')
         .map { |s1| s1.split(': ') }
         .map {|k,v| [k, v.to_i]}
    ]
  }
end
