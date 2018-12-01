require 'minitest/autorun'

class StepOneTest < MiniTest::Test
  def test_parse
  end

  def test_simple_input
    assert_equal(solve(['+1', '+1', '+1'].map(&method(:parse))), 3)
    assert_equal(solve(['+1', '+1', '-2'].map(&method(:parse))), 0)
    assert_equal(solve(['-1', '-2', '-3'].map(&method(:parse))), -6)
  end

  def test_complex_input
    assert_equal(0, solve2([1, -1]))
    assert_equal(10, solve2([3, 3, 4, -2, -4]))
    # assert_equal(5, solve2([6, 3, 8, 5, -6]))
    assert_equal(14, solve2([7, 7, -2, -7, -4]))
  end
end

def parse(line)
  line.to_i
end

def solve(lines)
  lines.sum
end

def solve2(lines)
  freqs = Enumerator.new do |y|
    n = 0
    lines.cycle.each do |i|
      n += i
      y << n
    end
  end

  freqs.each_with_object(0 => true) do |e, a|
    return e if a[e]

    a[e] = true
  end
end

def input
  File.readlines('day1.input')
    .map(&method(:parse))
end
