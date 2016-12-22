require 'minitest/autorun'
require './util'

class StepOneTest < MiniTest::Test
  def simple
    ['eedadn', 'drvtee', 'eandsr', 'raavrd', 'atevrs', 'tsrnev', 'sdttsa',
    'rasrtv', 'nssdts', 'ntnada', 'svetve', 'tesnvt', 'vntsnd', 'vrdear',
    'dvrsen', 'enarar']
  end

  def test_simple_input
    assert_equal 'easter', denoise(simple)
  end
end

def solve(lines)
  denoise(lines)
end

def solve2(lines)
  denoise(lines, :last)
end

def denoise(attempts, which = :first)
  range = (0...(attempts[0].length))
  range
    .each_with_object([]) do |i, o|
    o << Counting.histogram(attempts.each_with_object(i).map(&:[])).keys.send(which)
    end
    .join
end

def input
  File.readlines('day6.input')
    .map(&:strip)
end
