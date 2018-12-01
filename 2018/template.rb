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
end

def solve(lines)
end

def solve2(lines)
end

def input
  File.readlines('dayNN.input')
    .map(&method(:parse))
end
