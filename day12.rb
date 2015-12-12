require 'json'

def run
  solve(input)
end

def input
  JSON.parse(File.read('day12.input'))
end

def solve(input)
  sum(input)
end

def sum(obj)
  if obj.is_a? Array
    return obj.map(&method(:sum)).reduce(&:+)
  elsif obj.is_a? Hash
    return 0 if obj.values.any? { |v| v == 'red' }
    return obj.values.map(&method(:sum)).reduce(&:+)
  end
  obj.to_i
end
