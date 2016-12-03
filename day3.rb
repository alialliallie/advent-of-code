require 'minitest/autorun'

class StepOneTest < MiniTest::Test
  def test_parse
  end

  def test_simple_input
  end

  def test_complex_input
  end
end

def parse(line)
  line.split.map(&:to_i)
end

def solve(lines)
  lines.count { |sides|
    sides[0] + sides[1] > sides[2] &&
    sides[1] + sides[2] > sides[0] &&
    sides[0] + sides[2] > sides[1]
  }
end

def solve2(lines)
  lines.each_slice(3).map { |(a, b, c)|
    [[a[0], b[0], c[0]],
    [a[1], b[1], c[1]],
    [a[2], b[2], c[2]]]
  }.flatten(1).count { |sides|
    sides[0] + sides[1] > sides[2] &&
    sides[1] + sides[2] > sides[0] &&
    sides[0] + sides[2] > sides[1]
  }
end

def input
  File.readlines('day3.input')
    .map(&method(:parse))
end
